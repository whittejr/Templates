/**
* @file    main.h
* @brief   none
* @version 0.1.0
* @author  Your name here
* @date    2026-03-31
*/

#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

#include "stm32wbxx_hal.h"


extern TIM_HandleTypeDef htim2;

static void SystemClock_Config(void);

void Error_Handler(void);

#define LED_Pin GPIO_PIN_4
#define LED_GPIO_Port GPIOE


#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */

