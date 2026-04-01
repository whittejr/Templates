/**
* @file    it.c
* @brief   none
* @version 0.1.0
* @author  Your name here
* @date    2026-04-01
*/

#include "it.h"
#include "stm32f1xx_hal.h"

void SysTick_Handler(void) {
    HAL_IncTick();
}
