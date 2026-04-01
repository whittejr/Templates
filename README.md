---

## 🛠️ Prerequisites

To build, debug, and flash firmware on Windows, install:

- Docker Desktop (with WSL2 integration enabled)
- WSL2 (Windows Subsystem for Linux)
- Visual Studio Code
- Dev Containers extension (VSCode)
- USBIPD-WIN (for forwarding ST-Link to WSL)

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone <your_repository_link.git>
2. Start Docker Desktop

Make sure Docker is running.

3. Open in VSCode

Open the project folder in VSCode.

4. Reopen in container

Press:

F1 or Ctrl + Shift + P

Then select:

Dev Containers: Reopen in Container
5. Wait for environment setup

The first build may take a few minutes.

⚙️ Microcontroller Setup

All commands below must be executed inside the container terminal.

1. Check supported MCUs
/cmake/mcu/

Currently supported:

f1
wb
2. Download MCU dependencies

Example for STM32F1:

./tools/get_mcu.sh f1
3. Configure HAL

Go to:

/third_party/stm32cube<chip>/Drivers/STM32XXXX_HAL_DRIVER/Inc/

Rename:

stm32xxxx_hal_conf_template.h → stm32xxxx_hal_conf.h
4. Define your MCU

In the appropriate header file (e.g. stm32f1xx.h):

#define STM32F103xB
📦 Project Configuration

When changing MCU or creating a new project, update the following:

1. .vscode/launch.json
Set the correct target device
Update the svdFile path

Place your .svd file in:

/tools/svd/
2. .vscode/tasks.json
Update the "command" to match your build preset
3. /cmake/mcu/stm32xx.cmake

Configure:

Linker script (.ld)
Startup file (.s)
4. CMakePresets.json

Update:

{
  "MCU_FAMILY": "f1",
  "TARGET_MCU": "STM32F103C8"
}
🔌 ST-Link Setup (USBIPD)

Since the container runs inside WSL2, USB devices must be forwarded manually.

1. Connect your board

Plug the STM32 (ST-Link) into USB.

2. Open PowerShell as Administrator
3. List USB devices
usbipd list
4. Bind device
usbipd bind --busid <BUS-ID>
5. Attach to WSL
usbipd attach --wsl --busid <BUS-ID>

✅ The ST-Link will now be available inside the container.
