# 🧠 Embedded STM32 Development Environment

Este repositório contém o código-fonte e o ambiente de desenvolvimento para firmware baseado em microcontroladores **STM32**.

O projeto utiliza um ambiente conteinerizado via **Docker**, garantindo que todas as ferramentas de build (CMake, toolchains, analisadores) estejam totalmente isoladas e padronizadas — sem poluir sua máquina host.

---

## 🛠️ Pré-requisitos da Máquina Host

Para compilar, debugar e gravar o firmware, sua máquina precisa apenas do essencial para rodar o container.

### 🔧 Requisitos gerais

- Docker Engine (ou Docker Desktop)
- VSCode
- Extensão **Dev Containers** no VSCode

---

### 🖥️ Configuração por sistema operacional

| Sistema Operacional | Ferramentas Necessárias | Configuração adicional |
|--------------------|------------------------|------------------------|
| **Geral (Todos)** | Docker + VSCode | Instalar extensão Dev Containers |
| **Windows (WSL2)** | USBIPD | Executar `wsl --update` |
| **Linux (Nativo)** | Nenhuma extra | Adicionar usuário aos grupos `dialout` ou `plugdev` |

---

## 🚀 Tutorial de Inicialização

Siga os passos abaixo para iniciar um novo projeto:

```bash
git clone <link_template.git>
Garanta que o Docker esteja rodando
Abra a pasta no VSCode
Pressione F1
Selecione:
Dev Containers: Reopen in Container
Aguarde a construção do ambiente
⚙️ Setup do microcontrolador

No terminal do VSCode (já dentro do container):

./tools/get_mcu.sh <familia>

Exemplo:

./tools/get_mcu.sh wb
🪟 Debug no Windows (USBIPD + WSL2)

Como o WSL2 não acessa USB diretamente, é necessário "injetar" o ST-Link:

Abra um PowerShell como administrador:

usbipd list

Identifique o BUS-ID, depois execute:

usbipd bind --busid <BUS-ID>
usbipd attach --wsl --busid <BUS-ID>
📦 Configuração para Novos Targets

O projeto foi estruturado para ser portável entre diferentes microcontroladores STM32.

Ao trocar o target, ajuste os seguintes pontos:

1️⃣ VSCode (.vscode/)
launch.json
Atualizar configFiles para o novo chip
Ajustar svdFile (/tools/svd/)
tasks.json
Alterar o target no parâmetro command (preset do CMake)
Clangd (IntelliSense)
Ajustar o caminho do compile_commands.json
Apontar para o diretório de build correto
2️⃣ CMake
CMakePresets.json
Atualizar:
name
MCU_FAMILY
TARGET_MCU
Ajustar diretórios de saída (build/debug/release)
3️⃣ Linker e Startup
Definir corretamente:
Arquivo .ld (linker)
Arquivo .s (startup)

Esses arquivos devem estar referenciados no .cmake da família:

/core/stm32xx.cmake
📁 Estrutura do Projeto
.
├── core/                # Configuração por família de MCU
├── tools/               # Scripts e SVDs
├── .vscode/             # Debug, tasks e IntelliSense
├── CMakePresets.json    # Presets de build
├── CMakeLists.txt       # Build principal
└── Dockerfile           # Ambiente conteinerizado