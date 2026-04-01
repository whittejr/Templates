🧠 Ambiente de Desenvolvimento STM32 (Windows)
Este repositório contém o ambiente de desenvolvimento e código-fonte para firmware baseado em microcontroladores STM32. Todo o projeto roda de forma isolada em um ambiente conteinerizado via Docker e WSL2, garantindo que as ferramentas de build e análise fiquem padronizadas e sem poluir a sua máquina host.

🛠️ Pré-requisitos (Máquina Host)
Para compilar, debugar e gravar o firmware no Windows, você precisará instalar:

Docker Desktop (com integração WSL2 ativada)

WSL2 (Windows Subsystem for Linux)

VSCode

Extensão Dev Containers (no VSCode)

USBIPD-WIN (ferramenta para repassar o ST-Link do Windows para o WSL)

🚀 Inicialização do Projeto
Siga os passos abaixo para carregar o ambiente conteinerizado:

Clone o repositório em sua máquina:

Bash
git clone <link_do_seu_repositorio.git>
Garanta que o Docker Desktop esteja rodando em segundo plano.

Abra a pasta do projeto no VSCode.

Pressione F1 (ou Ctrl+Shift+P) para abrir a paleta de comandos.

Digite e selecione: Dev Containers: Reopen in Container.

Aguarde o VSCode construir e iniciar o ambiente (isso pode levar alguns minutos na primeira vez).

⚙️ Setup do Microcontrolador
Com o terminal do VSCode aberto já dentro do container, configure a família do seu chip:

Verifique o suporte: Confirme se a família do seu chip existe na pasta /cmake/mcu/. (Atualmente suportados: wb e f1).

Baixe as dependências: Execute o script informando a família do chip. Exemplo para a família F1:

Bash
./tools/get_mcu.sh f1
Configure a HAL:

Navegue até a pasta: /third_party/stm32cube<chip>/Drivers/STM32XXXX_HAL_DRIVER/Inc/

Renomeie o arquivo stm32xxxx_hal_conf_template.h removendo o sufixo _template.

Defina o Chip: Certifique-se de adicionar o #define do seu chip específico no arquivo stm32xxxx.h correspondente (ex: #define STM32F103xB).

📦 Configuração do Target (Arquivos do Projeto)
Ao iniciar um novo projeto ou trocar de chip, você precisa ajustar as configurações de build e debug nos seguintes arquivos:

1️⃣ .vscode/launch.json (Debug)
Modifique o target para apontar para o chip correto.

Modifique o caminho do svdFile. (O arquivo SVD do seu microcontrolador deve ser colocado na pasta /tools/svd/).

2️⃣ .vscode/tasks.json (Tasks do VSCode)
Modifique o parâmetro "command" para refletir o preset/chip correto que será compilado.

3️⃣ /cmake/mcu/stm32xx.cmake (Linker e Startup)
Configure as linhas apontando para o LINKER_SCRIPT (.ld) e o STARTUP_FILE (.s) corretos para o seu modelo específico de chip.

4️⃣ CMakePresets.json (Presets de Build)
Na seção "cacheVariables", modifique apenas os valores de "MCU_FAMILY" e "TARGET_MCU" para corresponderem ao seu hardware.

🪟 Conectando o ST-Link (Debug via USBIPD)
Como o container roda dentro do WSL2, ele não tem acesso nativo às portas USB do Windows. Para conseguir gravar e debugar seu firmware, você precisa "injetar" a conexão do ST-Link:

Conecte sua placa STM32 (ST-Link) na porta USB do PC.

Abra o PowerShell no Windows como Administrador.

Liste os dispositivos USB conectados:

PowerShell
usbipd list
Identifique o BUS-ID referente ao seu ST-Link na lista.

Execute os comandos abaixo substituindo <BUS-ID> pelo número encontrado:

PowerShell
usbipd bind --busid <BUS-ID>
usbipd attach --wsl --busid <BUS-ID>
