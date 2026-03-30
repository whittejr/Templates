/**
 * @file gpio.h
 * @brief  none
 * @version 0.1
 * @author Alessandro Davi
 * @date 2025-11-05
 */

#ifndef GPIO_H
#define GPIO_H

#include "stm32wbxx_hal.h"
#include <stdint.h>

uint8_t gpio_init(void);

void bsp_gpio_write(GPIO_TypeDef *port, uint16_t pin, uint8_t state);
uint8_t bsp_gpio_read(GPIO_TypeDef *port, uint16_t pin);
void bsp_delay_ms(uint32_t ms);

#endif // GPIO_H
