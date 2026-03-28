/**
 * @file    main.c
 * @brief
 * @version 1.0.0
 * @author  Alessandro Davi
 * @date    2025-12-31
 */

#include "app_system.h"
#include "oximeter_hal.h"
#include <stdio.h>

void errorHandler(void);

int main(void) {
    if (app_system_init() != 0) errorHandler();

    while (1) {
        
    }
}

void errorHandler(void) {
    while (1);
}
