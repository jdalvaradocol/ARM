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
.equ RCC_AHB1ENR,     (RCC_BASE + 0x30)   /* Habilitación de reloj AHB1 */

.equ GPIOB_BASE,      0x40020400
.equ GPIOB_MODER,     (GPIOB_BASE + 0x00) /* Modo Puerto B */
.equ GPIOB_ODR,       (GPIOB_BASE + 0x14) /* Salida Puerto B */

.equ GPIOC_BASE,      0x40020800
.equ GPIOC_MODER,     (GPIOC_BASE + 0x00) /* Modo Puerto C */
.equ GPIOC_IDR,       (GPIOC_BASE + 0x10) /* Entrada Puerto C */

.equ GPIOE_BASE,      0x40021000
.equ GPIOE_MODER,     (GPIOE_BASE + 0x00) /* Modo Puerto E */
.equ GPIOE_IDR,       (GPIOE_BASE + 0x10) /* Entrada Puerto E */
.equ GPIOE_ODR,       (GPIOE_BASE + 0x14) /* Salida Puerto E */

.equ GPIOF_BASE,      0x40021400
.equ GPIOF_MODER,     (GPIOF_BASE + 0x00) /* Modo Puerto F */
.equ GPIOF_IDR,       (GPIOF_BASE + 0x10) /* Entrada Puerto F */
.equ GPIOF_ODR,       (GPIOF_BASE + 0x14) /* Salida Puerto F */


asm_main:
    /* 1. Habilitar reloj para GPIOB (Bit 1) y GPIOC (Bit 2) */
        LDR     R0, =RCC_AHB1ENR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 1) /* Activa GPIOBEN y GPIOBEN */
        ORR     R1, R1, #(1 << 2) /* Activa GPIOBEN y GPIOCEN */
        ORR     R1, R1, #(1 << 4) /* Activa GPIOBEN y GPIOEEN */
        ORR     R1, R1, #(1 << 5) /* Activa GPIOEEN y GPIOFEN */
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
        LDR     R0, =GPIOC_MODER         /* Corrección: Se usa GPIOC_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 26)       /* Modo Entrada (00) */
        STR     R1, [R0]

        /* 4. Configurar PE9  como Entrada General (bits [19:18] = '00') */
        /* 4. Configurar PE11 como Entrada General (bits [23:22] = '00') */
        /* 3. Configurar PE8  como Salida General (bits [17:16] = '01') */
        /* 3. Configurar PE7  como Salida General (bits [15:14] = '01') */
        /* 3. Configurar PE10 como Salida General (bits [21:20] = '01') */
        /* 3. Configurar PE12 como Salida General (bits [25:24] = '01') */

        LDR     R0, =GPIOE_MODER         /* Corrección: Se usa GPIOC_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 14)  /* Modo Entrada (00) */
        BIC     R1, R1, #(3 << 16)  /* Modo Entrada (00) */
        BIC     R1, R1, #(3 << 18)  /* Modo Entrada (00) */
        BIC     R1, R1, #(3 << 20)  /* Modo Entrada (00) */
        BIC     R1, R1, #(3 << 22)  /* Modo Entrada (00) */
        BIC     R1, R1, #(3 << 24)  /* Modo Entrada (00) */
        
        ORR     R1, R1, #(1 << 14) /* Modo Salida (01) */
        ORR     R1, R1, #(1 << 16) /* Modo Salida (01) */
        ORR     R1, R1, #(1 << 20) /* Modo Salida (01) */
        ORR     R1, R1, #(1 << 24) /* Modo Salida (01) */
        STR     R1, [R0]

        /* 4. Configurar PF13 como Entrada General (bits [27:26] = '00') */
        /* 4. Configurar PF14 como Entrada General (bits [29:28] = '00') */
        LDR     R0, =GPIOF_MODER         /* Corrección: Se usa GPIOC_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 26) /* Modo Entrada (00) */
        BIC     R1, R1, #(3 << 28) /* Modo Entrada (00) */
        STR     R1, [R0]

/* 5. Bucle principal */
bucle_principal:

		BL      leer_entrada
		BL      escribir_salida

        LDR     R0, =GPIOC_IDR
        LDR     R1, [R0]
        
        TST     R1, #(1 << 13)           /* Evalúa únicamente el bit 13 */
        BNE     rutina_true              /* Si Bit 13 == 1 (Botón presionado) */
        BEQ     rutina_false             /* Si Bit 13 == 0 (Botón no presionado) */

        B       bucle_principal

rutina_true:
    /* Parpadear LED1 (PB0) */
        LDR     R0, =GPIOB_ODR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 0)        /* Encender PB0 */
        STR     R1, [R0]
        BL      retardo
        
        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 0)        /* Apagar PB0 */
        STR     R1, [R0]
        BL      retardo

        B       bucle_principal

rutina_false:
    /* Parpadear LED2 (PB7) */
        LDR     R0, =GPIOB_ODR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 7)        /* Encender PB7 */
        STR     R1, [R0]
        
        BL      retardo

        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 7)        /* Apagar PB7 */
        STR     R1, [R0]
        
        BL      retardo

        B       bucle_principal

leer_entrada:
        LDR     R0, =GPIOE_IDR
        LDR     R1, [R0]

        // PE11 (SW2)
        AND     R2, R1, # (1 << 11)
        LSR     R3, R2, #9
        // PE9 (SW1)
        AND     R2, R1, # (1 << 9)
        LSR     R4, R2, #8

        LDR     R0, =GPIOF_IDR
        LDR     R1, [R0] 

        // PF13 (SW0)
        AND     R2, R1, # (1 << 13)
        LSR     R5, R2, #13
        // PF14 (SW3)
        AND     R2, R1, # (1 << 14)
        LSR     R6, R2, #11

        ORR     R3, R3, R4
        ORR     R3, R3, R5
        ORR     R3, R3, R6

        BX      LR 

escribir_salida:

		// PE8 (LEDO)
		AND		R4, R3, (1 << 0)
		LSL		R4, R3, #8

		// PE7 (LED1)
		AND		R5, R3, (1 << 1)
		LSL		R5, R5, #6

		// PE10 (LED2)
		AND		R6, R3, (1 << 2)
		LSL		R6, R6, #8

		// PE12 (LED3)
		AND		R7, R3, (1 << 3)
		LSL		R7, R7, #9

		ORR     R4, R4, R5
        ORR     R4, R4, R6
        ORR     R4, R4, R7

		LDR     R0, =GPIOE_ODR
        LDR     R1, [R0]
        STR     R4, [R0]

		BX      LR

/* Subrutina de Retardo */
retardo:
        LDR     R2, =1600000
loop_retardo:
        SUBS    R2, R2, #1
        BNE     loop_retardo
        BX      LR

.size asm_main, .-asm_main
