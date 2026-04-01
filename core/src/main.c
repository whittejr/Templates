/**
* @file    main.c
* @brief   none
* @version 0.1.0
* @author  Your name here
* @date    2026-03-31
*/

#include "stm32wbxx_hal.h"

void SystemClock_Config(void);

int main(void)
{
    HAL_Init();
    // SystemClock_Config();

    // 1. Habilita clock do GPIOE
    __HAL_RCC_GPIOE_CLK_ENABLE();

    // 2. Configura PE4 como saída push-pull
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    GPIO_InitStruct.Pin = GPIO_PIN_4;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;

    HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

    while (1)
    {
        HAL_GPIO_TogglePin(GPIOE, GPIO_PIN_4);
        HAL_Delay(1000);
    }
}