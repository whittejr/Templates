// stm32wbxx_it.c
#include "max30102.h"
#include "stm32wbxx_hal.h"
#include "stm32wbxx_hal_tim.h"
extern TIM_HandleTypeDef htim16;
extern volatile uint8_t g_oximeter_event;

void SysTick_Handler(void) {
    HAL_IncTick();
}

void EXTI4_IRQHandler(void) {
    HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_4);

    g_oximeter_event = 1;
}

// void TIM1_UP_TIM16_IRQHandler(void) {
//     HAL_TIM_IRQHandler(&htim16);
// }
