/**
 * @file    delay.c
 * @brief   none
 * @version 0.1.0
 * @author  
 * @date    
 */

#include "delay.h"
#include "stm32wbxx_hal.h"

void delay_ms(uint32_t ms) {
    HAL_Delay(ms);
}