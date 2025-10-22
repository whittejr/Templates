#include "stm32wb55xx.h"

// Protótipos
void delay(unsigned long delay_ms);
void gpio_init(void);
void gpio_set_high(void);
void gpio_set_low(void);

/**
 * @brief Delay simples baseado em loop (bloqueante e impreciso)
 */
void delay(unsigned long delay_ms) {
    for (unsigned long i = 0; i < delay_ms * 400; i++) {
        __asm("nop"); // Ciclo de espera
    }
}

/**
 * @brief Inicializa o pino PE4 como saída
 */
void gpio_init(void) {
    // 1. Habilita o clock do GPIOE
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOEEN;

    // 2. Configura PE4 como saída
    GPIOE->MODER &= ~(3U << (4 * 2)); // Limpa os bits do pino 4
    GPIOE->MODER |=  (1U << (4 * 2)); // Configura como output (01)

    // 3. Tipo push-pull
    GPIOE->OTYPER &= ~(1U << 4);

    // 4. Velocidade baixa
    GPIOE->OSPEEDR &= ~(3U << (4 * 2));

    // 5. Sem pull-up/pull-down
    GPIOE->PUPDR &= ~(3U << (4 * 2));
}

/**
 * @brief Seta PE4
 */
void gpio_set_high(void) {
    GPIOE->BSRR = (1U << 4);
}

/**
 * @brief Reseta PE4
 */
void gpio_set_low(void) {
    GPIOE->BSRR = (1U << (4 + 16));
}

/**
 * @brief Função principal
 */
uint8_t test = 0;
int main(void) {
    
    gpio_init();

    while (1) {
        gpio_set_high();
        test = 1;
        delay(500);
        gpio_set_low();
        test = 0;
        delay(500);
    }
    return 0;
}
/*
*/