/**
 * @file uart.h
 * @brief  none
 * @version 0.1
 */

#ifndef UART_H
#define UART_H

#include <stdint.h>

/*
* @brief       
* @param[in]   
* @return      
*            - 
*            - 
* @note       
*/
uint8_t uart_init(void);

/*
* @brief       
* @param[in]   
* @return      
*            - 
*            - 
* @note       
*/
uint8_t uart_deinit(void);

/*
* @brief       
* @param[in]   
* @return      
*            - 
*            - 
* @note       
*/
void uart_write(uint8_t *buf, uint16_t len);

#endif // UART_H
