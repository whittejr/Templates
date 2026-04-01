Ambiente de Desenvolvimento STM32 (Windows)

Este repositório contém o ambiente de desenvolvimento e código-fonte para firmware baseado em microcontroladores STM32. Todo o projeto roda de forma isolada em um ambiente conteinerizado via Docker e WSL2, garantindo padronização total das ferramentas sem poluir a máquina host.

🛠️ Pré-requisitos (Máquina Host)
Docker Desktop (com integração WSL2 ativada)
WSL2 (Windows Subsystem for Linux)
VSCode
Extensão Dev Containers (VSCode)
USBIPD-WIN (para repassar o ST-Link ao WSL)
Inicialização do Projeto
1. Clone o repositório
git clone <link_do_seu_repositorio.git>
2. Inicie o Docker Desktop
3. Abra no VSCode
4. Reabra no container

Pressione F1 ou Ctrl + Shift + P:

Dev Containers: Reopen in Container
5. Aguarde o build

(Pode levar alguns minutos na primeira execução)

⚙️ Setup do Microcontrolador
1. Verifique suporte
/cmake/mcu/

Suportados: wb, f1

2. Baixe dependências
./tools/get_mcu.sh f1
3. Configure a HAL

Caminho:

/third_party/stm32cube<chip>/Drivers/STM32XXXX_HAL_DRIVER/Inc/

Renomeie:

stm32xxxx_hal_conf_template.h → stm32xxxx_hal_conf.h
4. Defina o chip
#define STM32F103xB
📦 Configuração do Target
1️⃣ .vscode/launch.json
Ajustar target
Ajustar svdFile
2️⃣ .vscode/tasks.json
Ajustar "command"
3️⃣ /cmake/mcu/stm32xx.cmake
LINKER_SCRIPT
STARTUP_FILE
4️⃣ CMakePresets.json
{
  "MCU_FAMILY": "f1",
  "TARGET_MCU": "STM32F103C8"
}
🪟 ST-Link via USBIPD
1. Conecte a placa
2. Abra PowerShell (Admin)
3. Liste dispositivos
usbipd list
4. Bind
usbipd bind --busid <BUS-ID>
5. Attach
usbipd attach --wsl --busid <BUS-ID>

✅ O ST-Link estará disponível dentro do container.
