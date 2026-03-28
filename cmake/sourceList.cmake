# Lista de arquivos-fonte do projeto
set(source_list
# --- Arquivo de Startup (Assembly) ---
    ${PROJ_PATH}core/startup/startup_stm32wb55xx_cm4.s


    # --- Arquivos do core da Aplicação ---
    ${PROJ_PATH}core/src/main.c
    ${PROJ_PATH}core/src/it.c              # Adicione se tiver este arquivo para interrupções
    # ${PROJ_PATH}/core/src/stm32wbxx_hal_msp.c        # Adicione se tiver este arquivo para inicialização de periféricos
    ${PROJ_PATH}core/src/system_stm32wbxx.c

    
    # --- Seus lib Customizados ---
    
    # display
    # epaper
    ${PROJ_PATH}lib/components/display/ssd1681/ssd1681.c
    ${PROJ_PATH}lib/bsp/src/ssd1681_interface.c
    ${PROJ_PATH}app/display/app_display.c
    ${PROJ_PATH}app/display/assets/bmp.c
    # mip
    ${PROJ_PATH}lib/components/display/ls013b7dh03/ls013b7dh03.c
    ${PROJ_PATH}lib/bsp/src/ls013b7dh03_interface.c
    ${PROJ_PATH}lib/components/display/ls013b7dh03/shmfonts.c

    # oximeter
    ${PROJ_PATH}lib/components/max30102/max30102.c
    ${PROJ_PATH}lib/bsp/src/max30102_interface.c
    ${PROJ_PATH}app/oximeter/app_oximeter.c

    # ui
    ${PROJ_PATH}app/ui/ui_manager.c
    ${PROJ_PATH}app/ui/screens/screen_watchface.c
    ${PROJ_PATH}app/ui/screens/screen_menu.c
    ${PROJ_PATH}app/ui/screens/screen_oximeter.c

    # app_glue
    ${PROJ_PATH}app/display/display_hal.c
    ${PROJ_PATH}app/oximeter/oximeter_hal.c

    # system
    ${PROJ_PATH}app/system/app_system.c

    # Interface (SPI, etc)
    ${PROJ_PATH}lib/bsp/src/clock.c
    ${PROJ_PATH}lib/bsp/src/spi.c
    ${PROJ_PATH}lib/bsp/src/gpio.c
    ${PROJ_PATH}lib/bsp/src/delay.c
    ${PROJ_PATH}lib/bsp/src/i2c.c
    ${PROJ_PATH}lib/bsp/src/uart.c

    # --- lib da ST HAL (apenas os que você usa) ---
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_cortex.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_dma.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_exti.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_flash.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_gpio.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_pwr.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_pwr_ex.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_rcc.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_rcc_ex.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_spi.c   
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_tim.c       
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_i2c.c
    ${PROJ_PATH}lib/STM32WBxx_HAL_Driver/Src/stm32wbxx_hal_uart.c

)