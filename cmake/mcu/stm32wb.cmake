# ==============================================================================
# IDENTIDADE DO HARDWARE: STM32WB Series
# ==============================================================================
message(STATUS "Configurando paths e flags para a familia STM32WB...")

# Caminho base do submódulo que baixamos no terminal
set(VENDOR_DIR "${CMAKE_CURRENT_SOURCE_DIR}/third_party/stm32cubewb/Drivers")

# 1. DEFINIÇÃO DO STARTUP (Assembly) E LINKER SCRIPT
# Geralmente o Linker você copia pra sua pasta, ou usa o da ST
set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/Core/linker/stm32wb55xx_flash_cm4.ld")
set(STARTUP_FILE "${VENDOR_DIR}/CMSIS/Device/ST/STM32WBxx/Source/Templates/gcc/startup_stm32wb55xx_cm4.s")

# ==============================================================================
# 2. FONTES DA HAL (.c)
# ==============================================================================
# Aqui você lista os periféricos da ST que o seu projeto vai usar
set(HAL_SOURCES
    ${STARTUP_FILE}
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal.c"
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_cortex.c"
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_rcc.c"
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_rcc_ex.c"
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_gpio.c"
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_dma.c"
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_pwr.c"
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_pwr_ex.c"
    
    # Arquivo de inicialização do relógio do sistema (System Clock)
    "${VENDOR_DIR}/CMSIS/Device/ST/STM32WBxx/Source/Templates/system_stm32wbxx.c"
)

# ==============================================================================
# 3. INCLUDES DA HAL (.h)
# ==============================================================================
set(HAL_INCLUDES
    "${VENDOR_DIR}/STM32WBxx_HAL_Driver/Inc"
    "${VENDOR_DIR}/CMSIS/Device/ST/STM32WBxx/Include"
    "${VENDOR_DIR}/CMSIS/Core/Include"
)

# Definições globais para o código C saber qual é a placa
add_compile_definitions(
    USE_HAL_DRIVER
    ${TARGET_MCU} # Essa variável vem lá do CMakePresets.json!
)

# ==============================================================================
# 4. FLAGS ESPECÍFICAS DA CPU (Cortex-M4 com FPU)
# ==============================================================================
# O STM32WB55 tem um Cortex-M4 e unidade de ponto flutuante (FPU) de precisão simples
set(CPU_FLAGS "-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# Injeta as flags no compilador para arquivos C, C++ e Assembly
add_compile_options(
    $<$<COMPILE_LANGUAGE:C>:${CPU_FLAGS}>
    $<$<COMPILE_LANGUAGE:CXX>:${CPU_FLAGS}>
    $<$<COMPILE_LANGUAGE:ASM>:${CPU_FLAGS}>
)

# Injeta as flags no Linker (necessário para o GCC ativar o hardware FPU)
add_link_options(${CPU_FLAGS})