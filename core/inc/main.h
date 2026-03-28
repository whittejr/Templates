
/**
 * @file main.h
 * @brief  none
 * @version 0.1
 * @author Alessandro Davi
 * @date 2025-11-03
 */

#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* 2. O Include principal do HAL */
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

