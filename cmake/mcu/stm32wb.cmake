message(STATUS "Configurando paths e flags para a familia STM32WB...")

# Caminho base do submódulo que baixamos no terminal
set(THIRD_PARTY "${CMAKE_CURRENT_SOURCE_DIR}/lib/third_party/stm32cubewb/Drivers")

set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/core/linker/stm32wb55xx_flash_cm4.ld")
set(STARTUP_FILE "${CMAKE_CURRENT_SOURCE_DIR}/core/startup_stm32wb55xx_cm4.s")

set(HAL_SOURCES
    ${STARTUP_FILE}
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal.c"
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_cortex.c"
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_rcc.c"
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_rcc_ex.c"
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_gpio.c"
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_dma.c"
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_pwr.c"
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_pwr_ex.c"
    
    # Arquivo de inicialização do relógio do sistema (System Clock)
    "${THIRD_PARTY}/CMSIS/Device/ST/STM32WBxx/Source/Templates/system_stm32wbxx.c"
)

# ==============================================================================
# 3. INCLUDES DA HAL (.h)
# ==============================================================================
set(HAL_INCLUDES
    "${THIRD_PARTY}/STM32WBxx_HAL_Driver/Inc"
    "${THIRD_PARTY}/CMSIS/Device/ST/STM32WBxx/Include"
    "${THIRD_PARTY}/CMSIS/Core/Include"
)

# Definições globais para o código C saber qual é a placa
add_compile_definitions(
    USE_HAL_DRIVER
    ${TARGET_MCU} # Essa variável vem lá do CMakePresets.json!
)

# ==============================================================================
# 4. FLAGS ESPECÍFICAS DA CPU (Cortex-M4 com FPU)
# ==============================================================================
set(CPU_FLAGS -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard)

# Aplica as flags diretamente para todos os compiladores (C, C++ e ASM)
add_compile_options(${CPU_FLAGS})

# Injeta as flags no Linker
add_link_options(${CPU_FLAGS})