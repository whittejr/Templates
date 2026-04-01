/**
* @file    main.c
* @brief   none
* @version 0.1.0
* @a* @author  Your name here
* @date    2026-03-31
*/

#include "stm32f1xx_hal.h"

#define led_pin GPIO_PIN_13
#define led_port GPIOC

void clk_enable(void);

int main(void)
{
    HAL_Init();

    clk_enable();

    GPIO_InitTypeDef GPIO_InitStruct = {0};
    GPIO_InitStruct.Pin = led_pin;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(led_port, &GPIO_InitStruct);

    while (1)
    {
        HAL_GPIO_TogglePin(led_port, led_pin);
        HAL_Delay(1000);
    }
    return 0;
}

void clk_enable(void) {
    __HAL_RCC_GPIOC_CLK_ENABLE();
}