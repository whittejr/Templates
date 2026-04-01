<div align="center">
  <h1>🧠 Ambiente de Desenvolvimento STM32</h1>
  <p>Um workspace isolado e conteinerizado para desenvolvimento moderno de firmware STM32.</p>

  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/C-00599C?style=flat-square&logo=c&logoColor=white" alt="C" />
  <img src="https://img.shields.io/badge/CMake-064F8C?style=flat-square&logo=cmake&logoColor=white" alt="CMake" />
  <img src="https://img.shields.io/badge/STM32-03234B?style=flat-square&logo=stmicroelectronics&logoColor=white" alt="STM32" />
  <img src="https://img.shields.io/badge/WSL2-FCC624?style=flat-square&logo=linux&logoColor=black" alt="WSL2" />
  <br>
  <br>
  <i>Leia em outros idiomas: <a href="README.md">English</a></i>
</div>

---

## 📖 Introdução

Este repositório contém o ambiente de desenvolvimento e código-fonte para firmware baseado em **microcontroladores STM32**. Utilizando **Docker** e **WSL2**, o projeto garante que todas as ferramentas de build, toolchains e analisadores fiquem totalmente isolados e padronizados, sem poluir a sua máquina host.

### Por que usar este ambiente?

Este projeto visa simplificar o desenvolvimento embarcado fornecendo um workspace reprodutível. Os princípios centrais incluem:

* 🔵 **Isolamento:** Rode tudo dentro de um container, mantendo seu Windows limpo.
* 🟢 **Padronização:** As mesmas ferramentas e versões para todos no projeto.
* 🟡 **Debug Integrado:** Integração fluida com VSCode, USBIPD e ST-Link.
* 🟣 **Portabilidade:** Estrutura fácil de escalar e adaptar para diferentes famílias STM32.

---

## 📑 Índice

1. [Pré-requisitos](#-pré-requisitos)
2. [Inicialização do Projeto](#-inicialização-do-projeto)
3. [Setup do Microcontrolador](#-setup-do-microcontrolador)
4. [Configuração do Target](#-configuração-do-target)
5. [Debug via USBIPD](#-debug-via-usbipd)

---

## 🛠️ Pré-requisitos

Para compilar, debugar e gravar o firmware no Windows, você precisará ter instalado na sua máquina host:

* **Docker Desktop** (com integração WSL2 ativada)
* **WSL2** (Windows Subsystem for Linux)
* **VSCode** com a Extensão **Dev Containers**
* **USBIPD-WIN** (ferramenta para repassar o ST-Link do Windows para o WSL)

---

## 🚀 Inicialização do Projeto

Execute o comando abaixo no seu terminal para clonar o repositório:

git clone <link_do_seu_repositorio.git>
Passos para inicialização:

Garanta que o Docker Desktop esteja rodando em segundo plano.

Abra a pasta do projeto no VSCode.

Pressione F1 (ou Ctrl+Shift+P) para abrir a paleta de comandos.

Digite e selecione: Dev Containers: Reopen in Container.

Aguarde o VSCode construir e iniciar o ambiente.

⚙️ Setup do Microcontrolador
Com o terminal do VSCode aberto já dentro do container, configure a família do seu chip:

Verifique o suporte: Confirme se a família do seu chip existe em /cmake/mcu/ (Atualmente suportados: wb, f1).

Baixe as dependências: Execute o script informando a família:

Bash
./tools/get_mcu.sh f1
Configure a HAL: Navegue até /third_party/stm32cube<chip>/Drivers/STM32XXXX_HAL_DRIVER/Inc/ e renomeie o arquivo stm32xxxx_hal_conf_template.h, removendo o sufixo _template.

Defina o Chip: Adicione o #define do seu chip específico no arquivo stm32xxxx.h correspondente (ex: #define STM32F103xB).

📦 Configuração do Target
Ao iniciar um novo projeto ou trocar de chip, ajuste as configurações nos seguintes arquivos:

.vscode/launch.json * Modifique o target para o chip correto.

Modifique o caminho do svdFile (coloque o SVD na pasta /tools/svd/).

.vscode/tasks.json * Modifique o "command" para refletir o preset/chip correto.

/cmake/mcu/stm32xx.cmake * Configure as linhas apontando para o LINKER_SCRIPT (.ld) e STARTUP_FILE (.s) corretos.

CMakePresets.json * Em "cacheVariables", modifique apenas "MCU_FAMILY" e "TARGET_MCU".

🪟 Debug via USBIPD
Como o container roda dentro do WSL2, ele não tem acesso nativo às portas USB do Windows. Para gravar e debugar, repasse a conexão:

Conecte sua placa STM32 (ST-Link) na porta USB do PC.

Abra o PowerShell no Windows como Administrador.

Liste os dispositivos USB conectados:

PowerShell
usbipd list
Identifique o BUS-ID referente ao seu ST-Link.

Execute os comandos substituindo <BUS-ID>:

PowerShell
usbipd bind --busid <BUS-ID>
usbipd attach --wsl --busid <BUS-ID>
