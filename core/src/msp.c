// msp.c
#include "stm32wb55xx.h"
#include "stm32wbxx_hal.h"
extern TIM_HandleTypeDef htim16;

void HAL_TIM_Base_MspInit(TIM_HandleTypeDef* tim_baseHandle)
{
    if(tim_baseHandle->Instance == TIM16)
    {
        // 1. Habilita clock do TIM16
        __HAL_RCC_TIM16_CLK_ENABLE();

        // 2. Configura NVIC para TIM16
        HAL_NVIC_SetPriority(TIM1_UP_TIM16_IRQn, 0, 0);
        HAL_NVIC_EnableIRQ(TIM1_UP_TIM16_IRQn);
    }
}

void HAL_TIM_Base_MspDeInit(TIM_HandleTypeDef* tim_baseHandle)
{
    if(tim_baseHandle->Instance == TIM16)
    {
        __HAL_RCC_TIM16_CLK_DISABLE();
        HAL_NVIC_DisableIRQ(TIM1_UP_TIM16_IRQn);
    }
}
