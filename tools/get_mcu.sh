#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "❌ Error: Missing MCU family parameter."
    echo "💡 Usage: ./get_mcu.sh <family> (e.g., ./get_mcu.sh wb)"
    exit 1
fi

FAMILY=$(echo "$1" | tr '[:upper:]' '[:lower:]')
REPO_URL="https://github.com/STMicroelectronics/stm32cube${FAMILY}.git"
TARGET_DIR="lib/third_party/stm32cube${FAMILY}"
PROJECT_ROOT="$(git rev-parse --show-toplevel)"

cd "$PROJECT_ROOT"

# ==============================================================================
# 1. INIT REPOSITORY (Ghost Clone + Absolute Auto-Heal)
# ==============================================================================
if [ ! -d "$TARGET_DIR" ] || ! git -C "$TARGET_DIR" rev-parse HEAD >/dev/null 2>&1; then
    echo "🧹 Preparing clean environment..."
    
    # --- A MUDANÇA ESTÁ AQUI ---
    # Garante que a estrutura de pastas dentro de .git/modules exista
    mkdir -p ".git/modules/$(dirname "$TARGET_DIR")"
    # ---------------------------

    git submodule deinit -f "$TARGET_DIR" 2>/dev/null || true
    rm -rf ".git/modules/$TARGET_DIR" "$TARGET_DIR"
    
    echo "📦 Fetching repository data..."
    
    # Agora o Git vai achar a pasta para colocar os metadados
    git clone --depth 1 --no-checkout --separate-git-dir ".git/modules/$TARGET_DIR" "$REPO_URL" "$TARGET_DIR"
    
    git config -f .gitmodules "submodule.$TARGET_DIR.path" "$TARGET_DIR"
    git config -f .gitmodules "submodule.$TARGET_DIR.url" "$REPO_URL"
    git add .gitmodules "$TARGET_DIR" 2>/dev/null || true
fi

# ==============================================================================
# 2. DYNAMIC MAPPING
# ==============================================================================
cd "$TARGET_DIR"
mapfile -t DIRS < <(git ls-tree -d --name-only HEAD)
mapfile -t FILES < <(git ls-tree HEAD | awk '$2 == "blob" {print $4}')
cd "$PROJECT_ROOT"

ITEMS=("${DIRS[@]}" "${FILES[@]}")
NUM_DIRS=${#DIRS[@]}
TOTAL_ITEMS=${#ITEMS[@]}

declare -a STATE
for i in "${!ITEMS[@]}"; do
    [[ "${ITEMS[$i]}" == "Drivers" ]] && STATE[$i]=1 || STATE[$i]=0
done

# ==============================================================================
# 3. INTERACTIVE TERMINAL UI
# ==============================================================================
CURSOR=0
MAX_ROWS=$((TOTAL_ITEMS + 2))

tput civis
trap "tput cnorm" EXIT
set +e

draw_menu() {
    clear
    echo "========================================================="
    echo "📂 STM32${FAMILY^^} MODULE MANAGER"
    echo "========================================================="
    echo "Navigate: [↑/↓] | Toggle: [SPACE] | Confirm: [ENTER]"
    echo "Unselected items will never touch your disk."
    echo ""
    
    for i in "${!ITEMS[@]}"; do
        local prefix="  "
        local box="[ ]"
        local icon="📄"
        local color="\033[0;37m"

        [[ $i -eq $CURSOR ]] && prefix="> "
        [[ ${STATE[$i]} -eq 1 ]] && box="[x]"
        
        if [ $i -lt $NUM_DIRS ]; then
            icon="📂"
            color="\033[0;36m"
        fi
        
        [[ $i -eq $CURSOR ]] && color="\033[1;32m"

        echo -e "${color}${prefix}${box} ${icon} ${ITEMS[$i]}\033[0m"
    done

    echo ""
    local del_color="\033[0m"
    local app_color="\033[0m"
    local p_del="  "
    local p_app="  "

    [[ $CURSOR -eq $TOTAL_ITEMS ]] && del_color="\033[1;31m" && p_del="> "
    [[ $CURSOR -eq $((TOTAL_ITEMS + 1)) ]] && app_color="\033[1;32m" && p_app="> "

    echo -e "${del_color}${p_del}🗑️  DELETE ALL (Remove library and clean cache)\033[0m"
    echo -e "${app_color}${p_app}✅ APPLY SELECTION\033[0m"
    echo "========================================================="
}

ACTION=""

while true; do
    draw_menu
    read -rsn1 key
    
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key2
        [[ $key2 == '[A' ]] && ((CURSOR--))
        [[ $key2 == '[B' ]] && ((CURSOR++))
        [[ $CURSOR -lt 0 ]] && CURSOR=$((MAX_ROWS - 1))
        [[ $CURSOR -ge $MAX_ROWS ]] && CURSOR=0
    elif [[ $key == ' ' && $CURSOR -lt $TOTAL_ITEMS ]]; then
        STATE[$CURSOR]=$((1 - STATE[$CURSOR]))
    elif [[ $key == '' ]]; then
        if [[ $CURSOR -lt $TOTAL_ITEMS ]]; then
            STATE[$CURSOR]=$((1 - STATE[$CURSOR]))
        elif [[ $CURSOR -eq $TOTAL_ITEMS ]]; then
            ACTION="DELETE"
            break
        elif [[ $CURSOR -eq $((TOTAL_ITEMS + 1)) ]]; then
            ACTION="APPLY"
            break
        fi
    fi
done

set -e
tput cnorm
clear

# ==============================================================================
# 4. EXECUTION
# ==============================================================================
if [[ "$ACTION" == "DELETE" ]]; then
    echo "🗑️  Removing library entirely..."
    git submodule deinit -f "$TARGET_DIR" 2>/dev/null || true
    rm -rf ".git/modules/$TARGET_DIR" "$TARGET_DIR"
    git config --remove-section submodule.$TARGET_DIR 2>/dev/null || true
    git rm -f "$TARGET_DIR" 2>/dev/null || true
    echo "✅ Cleanup complete."
    exit 0
fi

if [[ "$ACTION" == "APPLY" ]]; then
    FILTER=""
    for i in "${!ITEMS[@]}"; do
        if [[ ${STATE[$i]} -eq 1 ]]; then
            [[ $i -lt $NUM_DIRS ]] && FILTER+=" ${ITEMS[$i]}/" || FILTER+=" ${ITEMS[$i]}"
        fi
    done

    if [[ -z "$FILTER" ]]; then
        echo "❌ No items selected. Aborting."
        exit 1
    fi

    echo "🚀 Applying strict sparse-checkout filters..."
    cd "$PROJECT_ROOT/$TARGET_DIR"
    git sparse-checkout set --no-cone $FILTER
    
    echo "⚙️  Extracting ONLY your selected files to the hard drive..."
    git checkout -f HEAD 2>/dev/null
    
    # === A MUDANÇA ESTÁ AQUI ===
    # Nós continuamos DENTRO da pasta da ST para que o Git leia o .gitmodules interno dela!
    echo "🔗 Updating nested submodules (HAL & CMSIS Device)..."
    
    for i in "${!ITEMS[@]}"; do
        if [[ ${STATE[$i]} -eq 1 && $i -lt $NUM_DIRS ]]; then
            # Passamos apenas o nome da pasta (ex: "Drivers") e tiramos o silenciador de erro
            git submodule update --init --recursive --depth 1 "${ITEMS[$i]}" || true
        fi
    done
    
    # Volta para a raiz para finalizar
    cd "$PROJECT_ROOT"
    echo "✅ Setup complete! Workspace is perfectly clean and fully updated."
fi