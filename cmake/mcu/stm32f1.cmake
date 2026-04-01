message(STATUS "Configurando paths e flags para a familia STM32F1...")

# Ajuste o caminho para o repositório do STM32CubeF1
set(THIRD_PARTY "${CMAKE_CURRENT_SOURCE_DIR}/lib/third_party/stm32cubef1/Drivers")

# Arquivos específicos da série F1 (Exemplo para o F103)
set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/core/linker/stm32f103xb_flash.ld")
set(STARTUP_FILE "${CMAKE_CURRENT_SOURCE_DIR}/core/startup_stm32f103xb.s")

set(HAL_SOURCES
    ${STARTUP_FILE}
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c"
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c"
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c"
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c"
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c"
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c"
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c"
    # F1 não costuma ter pwr_ex em todos os modelos, mas o HAL base inclui o necessário
    
    "${THIRD_PARTY}/CMSIS/Device/ST/STM32F1xx/Source/Templates/system_stm32f1xx.c"
)

set(HAL_INCLUDES
    "${THIRD_PARTY}/STM32F1xx_HAL_Driver/Inc"
    "${THIRD_PARTY}/CMSIS/Device/ST/STM32F1xx/Include"
    "${THIRD_PARTY}/CMSIS/Core/Include"
)

add_compile_definitions(
    USE_HAL_DRIVER
    ${TARGET_MCU} # Deve ser algo como STM32F103xB no seu CMakePresets.json
)

# Flags para Cortex-M3 (Sem FPU)
set(CPU_FLAGS -mthumb -mcpu=cortex-m3 -mfloat-abi=soft)

add_compile_options(${CPU_FLAGS})
add_link_options(${CPU_FLAGS})