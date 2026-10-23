/*
 * main.s - Control de LEDs con botón en ensamblador puro
 * Tarjeta: NUCLEO-F429ZI
 * Microcontrolador: STM32F429ZIT6
 * Periféricos: LED1 (Verde) en PB0, LED2 (Azul) en PB7, Botón B1 en PC13
 */

.syntax unified
.cpu cortex-m4
.thumb

.global     asm_main
.type       asm_main, %function

.section .text

/* --- Mapa de Direcciones MMIO --- */
.equ RCC_BASE,        0x40023800
.equ RCC_AHB1ENR,     (RCC_BASE + 0x30)  /* Habilitación de reloj AHB1 */

.equ GPIOB_BASE,      0x40020400
.equ GPIOB_MODER,     (GPIOB_BASE + 0x00) /* Modo Puerto B */
.equ GPIOB_ODR,       (GPIOB_BASE + 0x14) /* Salida Puerto B */

.equ GPIOC_BASE,      0x40020800
.equ GPIOC_MODER,     (GPIOC_BASE + 0x00) /* Modo Puerto C */
.equ GPIOC_IDR,       (GPIOC_BASE + 0x10) /* Entrada Puerto C */

asm_main:
    /* 1. Habilitar reloj para GPIOB (Bit 1) y GPIOC (Bit 2) en un solo paso */
        LDR     R0, =RCC_AHB1ENR
        LDR     R1, [R0]
        ORR     R1, R1, #((1 << 1) | (1 << 2))   /* Habilita GPIOBEN y GPIOCEN */
        STR     R1, [R0]

    /* 2. Configurar PB0 (LED1) como Salida General (bits [1:0] = '01') */
        LDR     R0, =GPIOB_MODER
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 0)        /* Limpia bits 1:0 */
        ORR     R1, R1, #(1 << 0)        /* Modo Salida (01) */
        STR     R1, [R0]

    /* 3. Configurar PB7 (LED2) como Salida General (bits [15:14] = '01') */
        LDR     R0, =GPIOB_MODER
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 14)       /* Limpia bits 15:14 */
        ORR     R1, R1, #(1 << 14)       /* Modo Salida (01) */
        STR     R1, [R0]

    /* 4. Configurar PC13 (Botón) como Entrada General (bits [27:26] = '00') */
        LDR     R0, =GPIOC_MODER
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 26)       /* Modo Entrada (00) */
        STR     R1, [R0]

/* 5. Bucle principal */
bucle_principal:
        LDR     R0, =GPIOC_IDR
        LDR     R1, [R0]

        TST     R1, #(1 << 13)           /* Comprueba el estado del Bit 13 */
        BNE     rutina_true              /* Si Bit 13 == 1 (Botón presionado) */
        B       rutina_false             /* Si Bit 13 == 0 (Botón suelto) */

rutina_true:
    /* Apaga LED1 (PB0) para prevenir que permanezca encendido */
        LDR     R0, =GPIOB_ODR
        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 0)
        STR     R1, [R0]

    /* Parpadeo de LED2 (PB7) */
        ORR     R1, R1, #(1 << 7)        /* Encender PB7 */
        STR     R1, [R0]
        BL      retardo

        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 7)        /* Apagar PB7 */
        STR     R1, [R0]
        BL      retardo

        B       bucle_principal

rutina_false:
    /* Apaga LED2 (PB7) para prevenir que permanezca encendido */
        LDR     R0, =GPIOB_ODR
        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 7)
        STR     R1, [R0]

    /* Parpadeo de LED1 (PB0) */
        ORR     R1, R1, #(1 << 0)        /* Encender PB0 */
        STR     R1, [R0]
        BL      retardo

        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 0)        /* Apagar PB0 */
        STR     R1, [R0]
        BL      retardo

        B       bucle_principal

/* Subrutina de Retardo */
retardo:
        LDR     R2, =1600000            /* Ajustar según frecuencia del Core */
loop_retardo:
        SUBS    R2, R2, #1
        BNE     loop_retardo
        BX      LR

.size asm_main, .-asm_main
