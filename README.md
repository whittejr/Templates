# Embedded Environment 🇬🇧 / 🇧🇷
*For the Portuguese version, [click here](#embedded-environment-🇧🇷).*

This repository contains the source code and the development environment for firmware based on STM32 microcontrollers. The project uses a containerized environment via Docker, ensuring isolated and standardized build tools (CMake, toolchains) across different operating systems.

## 🛠️ Environment & Prerequisites

To build, debug, and flash the firmware, you need the following tools configured on your host machine:

* **Docker:** Engine for running the development container.
* **VSCode:** With the *Dev Containers*, *C/C++*, and *clangd* extensions.

### OS-Specific Setup for Debugger (ST-Link)

To attach your USB debugger to the Docker container, the setup varies depending on your host OS:

#### 🐧 Linux (Native)
Docker can directly access USB devices on Linux. You just need to ensure your user has permission to access the ST-Link (usually by adding your user to the `dialout` or `plugdev` group, or by setting up the appropriate `udev` rules for STMicroelectronics devices). The dev container will handle the rest.

#### 🪟 Windows (WSL2)
You will need **WSL2**, **Docker Desktop** (with WSL2 integration), and **USBIPD** to attach the USB device from Windows into the WSL2 environment.

```cmd
usbipd list
usbipd bind --busid <BUS-ID>
usbipd attach --wsl --busid <BUS-ID>
```

---

## 📦 Dependencies & Target Configuration

This project is designed to be portable across different chips. If you need to change the target microcontroller, it is mandatory to adjust the following dependencies:

### 1. VSCode Dependencies (.vscode/)

**launch.json:**
- Update the `configFiles` target to the specific chip.
- Add/Update the `svdFile` path to point to the specific chip's `.svd` file (located in `/tools/svd/`).

**tasks.json:**
- Change the target specified in the `"command"` parameter.

**Clangd (IntelliSense):**
- The `CompilationDatabase` setting requires the exact debug path of the specific chip so IntelliSense can correctly locate the `compile_commands.json`.

---

### 2. CMake Dependencies

**CMakePresets.json:**
- Adjust the `"name"` of the preset.
- In `"cacheVariables"`, update the `"MCU_FAMILY"` and `"TARGET_MCU"` variables.
- Adjust the debug and release binary output directories to include the specific chip's name.

**Linker and Startup (/core/):**
- The linker (`.ld`) and startup (`.s`) files must be correctly defined and referenced inside `stm32wb.cmake` (located in the `/core/` folder).

---

# Embedded Environment 🇧🇷

Este repositório contém o código-fonte e o ambiente de desenvolvimento para o firmware baseado em microcontroladores STM32. O projeto utiliza um ambiente conteinerizado via Docker, garantindo que as ferramentas de build (CMake, toolchains) estejam isoladas e padronizadas em diferentes sistemas operacionais.

## 🛠️ Ambiente e Pré-requisitos

Para compilar, debugar e gravar o firmware, você precisará configurar o seguinte ambiente na sua máquina host:

- Docker: Motor para rodar o container de desenvolvimento.
- VSCode: Com as extensões Dev Containers, C/C++ e clangd.

### Configuração do Debugger (ST-Link) por Sistema Operacional

#### 🐧 Linux (Nativo)
O Docker consegue acessar os dispositivos USB nativamente no Linux. Você só precisa garantir que seu usuário tem permissão para acessar o ST-Link (geralmente adicionando o usuário ao grupo dialout ou plugdev, ou configurando as regras do udev para dispositivos STMicroelectronics). O dev container cuida do resto.

#### 🪟 Windows (WSL2)
Você precisará do WSL2, Docker Desktop (com integração ao WSL2 habilitada) e do USBIPD para anexar o dispositivo USB do Windows para dentro do ambiente WSL2.

```cmd
usbipd list
usbipd bind --busid <BUS-ID>
usbipd attach --wsl --busid <BUS-ID>
```

---

## 📦 Dependências e Configuração do Target

Este projeto foi desenhado para ser portável entre diferentes chips. Se você precisar alterar o microcontrolador alvo, é obrigatório ajustar as seguintes dependências:

### 1. Dependências do VSCode (.vscode/)

**launch.json:**
- Atualize o target na chave `configFiles` para o chip específico.
- Adicione/atualize a chave `svdFile` para apontar para o arquivo `.svd` do chip específico (localizado em `/tools/svd/`).

**tasks.json:**
- Altere o target especificado dentro do parâmetro `"command"`.

**Clangd (IntelliSense):**
- A configuração `CompilationDatabase` precisa do caminho exato da pasta de debug do chip específico para encontrar o `compile_commands.json` corretamente.

---

### 2. Dependências do CMake

**CMakePresets.json:**
- Ajuste o `"name"` do preset.
- Em `"cacheVariables"`, atualize as variáveis `"MCU_FAMILY"` e `"TARGET_MCU"`.
- Altere o diretório de saída dos binários nas configurações de debug e release para incluir o nome do chip específico.

**Linker e Startup (/core/):**
- Os arquivos de linker (`.ld`) e startup (`.s`) devem ser definidos e referenciados corretamente dentro do arquivo `stm32wb.cmake` (na pasta `/core/`).
