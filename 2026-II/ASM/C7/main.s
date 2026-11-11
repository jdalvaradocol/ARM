/*
 * =========================================================================
 * main.s - Control de LEDs, lectura de DIP switches, decodificador 7 seg y botón
 * Tarjeta: NUCLEO-F429ZI (Cortex-M4)
 * Microcontrolador: STM32F429ZIT6
 * 
 * MAPA DE PINES Y PERIFÉRICOS:
 *   - LEDs integrados (Nucleo): LED1 (Verde) -> PB0, LED2 (Azul) -> PB7
 *   - Botón B1 (Usuario): PC13 (Push-button activo en ALTO)
 *   - Entradas digitales DIP Switch (SW0..SW3): PF13, PE9, PE11, PF14
 *   - Salidas digitales a LEDs externos (LED0..LED3): PE8, PE7, PE10, PE12
 *   - Display de 7 Segmentos (Cátodo/Ánodo Común):
 *       Segmento A (Sa) -> PD11
 *       Segmento B (Sb) -> PD13
 *       Segmento C (Sc) -> PF4
 *       Segmento D (Sd) -> PB6
 *       Segmento E (Se) -> PB2
 *       Segmento F (Sf) -> PD12
 *       Segmento G (Sg) -> PC2
 *       Habilitación Dígito D0 -> PF12
 * =========================================================================
 */

.syntax unified              /* Sintaxis unificada ARM (Thumb/ARM32) */
.cpu cortex-m4               /* Núcleo ARM Cortex-M4 con soporte FPU/DSP */
.thumb                       /* Conjunto de instrucciones Thumb-2 (16/32 bits) */

.global     asm_main         /* Punto de entrada global exportado para el linker */
.type       asm_main, %function

.section .text               /* Sección de memoria de código ejecutable */

/* =========================================================================
   Mapa de Direcciones MMIO (Memory-Mapped I/O)
   ========================================================================= */

/* Reloj Periférico RCC (Reset and Clock Control) */
.equ RCC_BASE,        0x40023800
.equ RCC_AHB1ENR,     (RCC_BASE + 0x30)   /* Habilitación de reloj para el bus AHB1 */

/* GPIO Puerto A */
.equ GPIOA_BASE,      0x40020000
.equ GPIOA_MODER,     (GPIOA_BASE + 0x00) /* Configuración de Modo (Entrada/Salida/Alt/Analógico) */
.equ GPIOA_IDR,       (GPIOA_BASE + 0x10) /* Registro de Lectura de Entradas */
.equ GPIOA_ODR,       (GPIOA_BASE + 0x14) /* Registro de Escritura de Salidas */

/* GPIO Puerto B */
.equ GPIOB_BASE,      0x40020400
.equ GPIOB_MODER,     (GPIOB_BASE + 0x00) 
.equ GPIOB_IDR,       (GPIOB_BASE + 0x10) 
.equ GPIOB_ODR,       (GPIOB_BASE + 0x14) 

/* GPIO Puerto C */
.equ GPIOC_BASE,      0x40020800
.equ GPIOC_MODER,     (GPIOC_BASE + 0x00) 
.equ GPIOC_IDR,       (GPIOC_BASE + 0x10) 
.equ GPIOC_ODR,       (GPIOC_BASE + 0x14) 

/* GPIO Puerto D */
.equ GPIOD_BASE,      0x40020C00
.equ GPIOD_MODER,     (GPIOD_BASE + 0x00) 
.equ GPIOD_IDR,       (GPIOD_BASE + 0x10) 
.equ GPIOD_ODR,       (GPIOD_BASE + 0x14) 

/* GPIO Puerto E */
.equ GPIOE_BASE,      0x40021000
.equ GPIOE_MODER,     (GPIOE_BASE + 0x00) 
.equ GPIOE_IDR,       (GPIOE_BASE + 0x10) 
.equ GPIOE_ODR,       (GPIOE_BASE + 0x14) 

/* GPIO Puerto F */
.equ GPIOF_BASE,      0x40021400
.equ GPIOF_MODER,     (GPIOF_BASE + 0x00) 
.equ GPIOF_IDR,       (GPIOF_BASE + 0x10) 
.equ GPIOF_ODR,       (GPIOF_BASE + 0x14) 

/* =========================================================================
   Punto de Entrada: asm_main
   ========================================================================= */
asm_main:

    /* ---------------------------------------------------------------------
       1. Habilitar Relojes Periféricos en RCC_AHB1ENR
       --------------------------------------------------------------------- */
        LDR     R0, =RCC_AHB1ENR         /* R0 = Dirección de RCC_AHB1ENR */
        LDR     R1, [R0]                 /* R1 = Valor actual de RCC_AHB1ENR */
        ORR     R1, R1, #(1 << 0)        /* Bit 0 = 1: Habilita reloj GPIOA */
        ORR     R1, R1, #(1 << 1)        /* Bit 1 = 1: Habilita reloj GPIOB */
        ORR     R1, R1, #(1 << 2)        /* Bit 2 = 1: Habilita reloj GPIOC */
        ORR     R1, R1, #(1 << 3)        /* Bit 3 = 1: Habilita reloj GPIOD */
        ORR     R1, R1, #(1 << 4)        /* Bit 4 = 1: Habilita reloj GPIOE */
        ORR     R1, R1, #(1 << 5)        /* Bit 5 = 1: Habilita reloj GPIOF */
        STR     R1, [R0]                 /* Guarda la configuración en RCC_AHB1ENR */

    /* ---------------------------------------------------------------------
       2. Configuración de Modos en GPIOB
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOB_MODER         /* R0 = Dirección de GPIOB_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 0)        /* Limpia bits [1:0]   (PB0 - LED1 Verde) */
        BIC     R1, R1, #(3 << 2)        /* Limpia bits [3:2]   (PB1 - DP Punto decimal) */
        BIC     R1, R1, #(3 << 4)        /* Limpia bits [5:4]   (PB2 - Segmento E) */
        BIC     R1, R1, #(3 << 12)       /* Limpia bits [13:12] (PB6 - Segmento D) */
        BIC     R1, R1, #(3 << 14)       /* Limpia bits [15:14] (PB7 - LED2 Azul) */
        
        ORR     R1, R1, #(1 << 0)        /* Modo Salida '01' -> PB0 */
        ORR     R1, R1, #(1 << 2)        /* Modo Salida '01' -> PB1 */
        ORR     R1, R1, #(1 << 4)        /* Modo Salida '01' -> PB2 */
        ORR     R1, R1, #(1 << 12)       /* Modo Salida '01' -> PB6 */
        ORR     R1, R1, #(1 << 14)       /* Modo Salida '01' -> PB7 */
        STR     R1, [R0]

    /* ---------------------------------------------------------------------
       3. Configuración de Modos en GPIOC
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOC_MODER         /* R0 = Dirección de GPIOC_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 4)        /* Limpia bits [5:4]   (PC2 - Segmento G) */
        BIC     R1, R1, #(3 << 26)       /* Limpia bits [27:26] (PC13 - Botón B1 Entrada '00') */
        ORR     R1, R1, #(1 << 4)        /* Modo Salida '01' -> PC2 */
        STR     R1, [R0]

    /* ---------------------------------------------------------------------
       4. Configuración de Modos en GPIOD
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOD_MODER         /* R0 = Dirección de GPIOD_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 22)       /* Limpia bits [23:22] (PD11 - Segmento A) */
        BIC     R1, R1, #(3 << 24)       /* Limpia bits [25:24] (PD12 - Segmento F) */
        BIC     R1, R1, #(3 << 26)       /* Limpia bits [27:26] (PD13 - Segmento B) */
        BIC     R1, R1, #(3 << 28)       /* Limpia bits [29:28] (PD14 - Display D2) */
        BIC     R1, R1, #(3 << 30)       /* Limpia bits [31:30] (PD15 - Display D1) */
        
        ORR     R1, R1, #(1 << 22)       /* Modo Salida '01' -> PD11 */
        ORR     R1, R1, #(1 << 24)       /* Modo Salida '01' -> PD12 */
        ORR     R1, R1, #(1 << 26)       /* Modo Salida '01' -> PD13 */
        ORR     R1, R1, #(1 << 28)       /* Modo Salida '01' -> PD14 */
        ORR     R1, R1, #(1 << 30)       /* Modo Salida '01' -> PD15 */
        STR     R1, [R0]

    /* ---------------------------------------------------------------------
       5. Configuración de Modos en GPIOE
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOE_MODER         /* R0 = Dirección de GPIOE_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 14)       /* Limpia bits [15:14] (PE7 - LED1 externo) */
        BIC     R1, R1, #(3 << 16)       /* Limpia bits [17:16] (PE8 - LED0 externo) */
        BIC     R1, R1, #(3 << 18)       /* Limpia bits [19:18] (PE9 - Entrada SW1 '00') */
        BIC     R1, R1, #(3 << 20)       /* Limpia bits [21:20] (PE10 - LED2 externo) */
        BIC     R1, R1, #(3 << 22)       /* Limpia bits [23:22] (PE11 - Entrada SW2 '00') */
        BIC     R1, R1, #(3 << 24)       /* Limpia bits [25:24] (PE12 - LED3 externo) */
        
        ORR     R1, R1, #(1 << 14)       /* Modo Salida '01' -> PE7 */
        ORR     R1, R1, #(1 << 16)       /* Modo Salida '01' -> PE8 */
        ORR     R1, R1, #(1 << 20)       /* Modo Salida '01' -> PE10 */
        ORR     R1, R1, #(1 << 24)       /* Modo Salida '01' -> PE12 */
        STR     R1, [R0]

    /* ---------------------------------------------------------------------
       6. Configuración de Modos en GPIOF
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOF_MODER         /* R0 = Dirección de GPIOF_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 8)        /* Limpia bits [9:8]   (PF4 - Segmento C) */
        BIC     R1, R1, #(3 << 24)       /* Limpia bits [25:24] (PF12 - Display D0 Enable) */
        BIC     R1, R1, #(3 << 26)       /* Limpia bits [27:26] (PF13 - Entrada SW0 '00') */
        BIC     R1, R1, #(3 << 28)       /* Limpia bits [29:28] (PF14 - Entrada SW3 '00') */
        
        ORR     R1, R1, #(1 << 8)        /* Modo Salida '01' -> PF4 */
        ORR     R1, R1, #(1 << 24)       /* Modo Salida '01' -> PF12 */
        STR     R1, [R0]

/* =========================================================================
   Bucle Principal
   ========================================================================= */
bucle_principal:

        BL      leer_entrada             /* Lee SW0..SW3 y consolida el valor (0..15) en R3 */
        BL      escribir_salida          /* Activa los LEDs externos (PE8, PE7, PE10, PE12) según R3 */

        BL      decimal_segmentos        /* Decodifica R3 a patrón 7-seg en R1 */
        BL      display_salida           /* Actualiza los pines físicos de los segmentos */

        /* Habilitación activa del Dígito 0 (PF12) */
        LDR     R0, =GPIOF_ODR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 12)       /* Pone PF12 en ALTO para encender el dígito D0 */
        STR     R1, [R0]

        /* Evaluación del Botón de Usuario B1 (PC13) */
        LDR     R0, =GPIOC_IDR           /* Lee el estado del Puerto C */
        LDR     R1, [R0]
        
        TST     R1, #(1 << 13)           /* Comprueba el bit 13 (PC13) */
        BNE     rutina_true              /* Si PC13 == 1 (Presionado) -> Parpadea LED1 (Verde) */
        BEQ     rutina_false             /* Si PC13 == 0 (Suelto)     -> Parpadea LED2 (Azul) */

        B       bucle_principal          /* Ciclo infinito */

/* =========================================================================
   Subrutina: decimal_segmentos
   Entrada:   R3 -> Valor numérico (0 a 9)
   Salida:    R1 -> Máscara de bits de segmentos [DP, G, F, E, D, C, B, A]
   ========================================================================= */
decimal_segmentos:
        CMP     R3, #0
        BEQ     digitocero
        CMP     R3, #1
        BEQ     digitouno
        CMP     R3, #2
        BEQ     digitodos
        CMP     R3, #3
        BEQ     digitotres
        CMP     R3, #4
        BEQ     digitocuatro
        CMP     R3, #5
        BEQ     digitocinco
        CMP     R3, #6
        BEQ     digitoseis
        CMP     R3, #7
        BEQ     digitosiete
        CMP     R3, #8
        BEQ     digitoocho
        CMP     R3, #9
        BEQ     digitonueve

        MOV     R1, #0                   /* Si R3 > 9 o inválido, apaga todos los segmentos */
        BX      LR

digitocero:
        MOV     R1, #0xBF                /* 0b10111111 -> Segments A,B,C,D,E,F activos */
        BX      LR

digitouno:
        MOV     R1, #0x86                /* 0b10000110 -> Segments B,C activos */
        BX      LR

digitodos:
        MOV     R1, #0xDB                /* 0b11011011 -> Segments A,B,D,E,G activos */
        BX      LR

digitotres:
        MOV     R1, #0xCF                /* 0b11001111 -> Segments A,B,C,D,G activos */
        BX      LR

digitocuatro:
        MOV     R1, #0xE6                /* 0b11100110 -> Segments B,C,F,G activos */
        BX      LR

digitocinco:
        MOV     R1, #0xED                /* 0b11101101 -> Segments A,C,D,F,G activos */
        BX      LR

digitoseis:
        MOV     R1, #0xFD                /* 0b11111101 -> Segments A,C,D,E,F,G activos */
        BX      LR

digitosiete:
        MOV     R1, #0x87                /* 0b10000111 -> Segments A,B,C activos */
        BX      LR

digitoocho:
        MOV     R1, #0xFF                /* 0b11111111 -> Todos los segmentos + Punto activos */
        BX      LR

digitonueve:
        MOV     R1, #0xEF                /* 0b11101111 -> Segments A,B,C,D,F,G activos */
        BX      LR

/* -------------------------------------------------------------------------
   Rutina: rutina_true (Ejecutada cuando PC13 = 1)
   Acción: Parpadea LED1 (Verde / PB0) y retorna al bucle principal
   ------------------------------------------------------------------------- */
rutina_true:
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

/* -------------------------------------------------------------------------
   Rutina: rutina_false (Ejecutada cuando PC13 = 0)
   Acción: Parpadea LED2 (Azul / PB7) y retorna al bucle principal
   ------------------------------------------------------------------------- */
rutina_false:
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

/* =========================================================================
   Subrutina: leer_entrada
   Propósito: Lee los pines dispersos de los interruptores (SW0..SW3) y los
              empaqueta en el registro R3 como un entero de 4 bits [SW3..SW0].
   ========================================================================= */
leer_entrada:
        LDR     R0, =GPIOE_IDR           /* Lee el estado de GPIOE */
        LDR     R1, [R0]

        // PE11 (SW2) -> Extrae bit 11 y lo desplaza a la posición de bit 2 (11 - 9 = 2)
        AND     R2, R1, #(1 << 11)
        LSR     R3, R2, #9

        // PE9 (SW1) -> Extrae bit 9 y lo desplaza a la posición de bit 1 (9 - 8 = 1)
        AND     R2, R1, #(1 << 9)
        LSR     R4, R2, #8

        LDR     R0, =GPIOF_IDR           /* Lee el estado de GPIOF */
        LDR     R1, [R0] 

        // PF13 (SW0) -> Extrae bit 13 y lo desplaza a la posición de bit 0 (13 - 13 = 0)
        AND     R2, R1, #(1 << 13)
        LSR     R5, R2, #13

        // PF14 (SW3) -> Extrae bit 14 y lo desplaza a la posición de bit 3 (14 - 11 = 3)
        AND     R2, R1, #(1 << 14)
        LSR     R6, R2, #11

        /* Acumula mediante OR lógico el valor de 4 bits resultante en R3 */
        ORR     R3, R3, R4
        ORR     R3, R3, R5
        ORR     R3, R3, R6

        BX      LR

/* =========================================================================
   Subrutina: escribir_salida
   Propósito: Mapea los 4 bits empaquetados en R3 hacia las líneas de LEDs en GPIOE.
   ========================================================================= */
escribir_salida:

        // Bit 0 de R3 -> Mapear a PE8 (LED0): desplazamiento a la izquierda por 8 bits
        AND     R4, R3, #(1 << 0)
        LSL     R4, R4, #8

        // Bit 1 de R3 -> Mapear a PE7 (LED1): desplazamiento a la izquierda por 6 bits
        AND     R5, R3, #(1 << 1)
        LSL     R5, R5, #6

        // Bit 2 de R3 -> Mapear a PE10 (LED2): desplazamiento a la izquierda por 8 bits
        AND     R6, R3, #(1 << 2)
        LSL     R6, R6, #8

        // Bit 3 de R3 -> Mapear a PE12 (LED3): desplazamiento a la izquierda por 9 bits
        AND     R7, R3, #(1 << 3)
        LSL     R7, R7, #9

        /* Une las máscaras individuales */
        ORR     R4, R4, R5
        ORR     R4, R4, R6
        ORR     R4, R4, R7

        LDR     R0, =GPIOE_ODR           /* Escribe la palabra final en GPIOE_ODR */
        LDR     R1, [R0]
        STR     R4, [R0]

        BX      LR

/* =========================================================================
   Subrutina: display_salida
   Propósito: Toma los bits codificados de R1 y los aplica a los pines físicos de 
              los puertos GPIOD, GPIOF, GPIOB y GPIOC.
   ========================================================================= */
display_salida:

        // Bit 0 de R1 (Sa) -> Mapea a PD11 ( (bit 0 << 11) = bit 11 )
        AND     R4, R1, #(1 << 0)
        LSL     R5, R4, #11

        // Bit 1 de R1 (Sb) -> Mapea a PD13 ( (bit 1 << 12) = bit 13 )
        AND     R4, R1, #(1 << 1)
        LSL     R6, R4, #12

        // Bit 5 de R1 (Sf) -> Mapea a PD12 ( (bit 5 << 7) = bit 12 )
        AND     R4, R1, #(1 << 5)
        LSL     R7, R4, #7

        /* Actualiza pines PD11, PD12, PD13 en GPIOD */
        LDR     R0, =GPIOD_ODR
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 11)       /* Limpia PD11 */
        BIC     R8, R8, #(1 << 12)       /* Limpia PD12 */
        BIC     R8, R8, #(1 << 13)       /* Limpia PD13 */
        ORR     R8, R8, R5               /* Aplica Sa en PD11 */
        ORR     R8, R8, R6               /* Aplica Sb en PD13 */
        ORR     R8, R8, R7               /* Aplica Sf en PD12 */
        STR     R8, [R0]

        // Bit 2 de R1 (Sc) -> Mapea a PF4 ( (bit 2 << 2) = bit 4 )
        AND     R4, R1, #(1 << 2)
        LSL     R5, R4, #2

        /* Actualiza PF4 en GPIOF */
        LDR     R0, =GPIOF_ODR
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 4)        /* Limpia PF4 */
        ORR     R8, R8, R5               /* Aplica Sc en PF4 */
        STR     R8, [R0]

        // Bit 3 de R1 (Sd) -> Mapea a PB6 ( (bit 3 << 3) = bit 6 )
        AND     R4, R1, #(1 << 3)
        LSL     R5, R4, #3

        // Bit 4 de R1 (Se) -> Mapea a PB2 ( (bit 4 >> 2) = bit 2 )
        AND     R4, R1, #(1 << 4)
        LSR     R6, R4, #2

        /* Actualiza PB2 y PB6 en GPIOB */
        LDR     R0, =GPIOB_ODR
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 2)        /* Limpia PB2 */
        BIC     R8, R8, #(1 << 6)        /* Limpia PB6 */
        ORR     R8, R8, R5               /* Aplica Sd en PB6 */
        ORR     R8, R8, R6               /* Aplica Se en PB2 */
        STR     R8, [R0]

        // Bit 6 de R1 (Sg) -> Mapea a PC2 ( (bit 6 >> 4) = bit 2 )
        AND     R4, R1, #(1 << 6)
        LSR     R5, R4, #4

        /* Actualiza PC2 en GPIOC */
        LDR     R0, =GPIOC_ODR
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 2)        /* Limpia PC2 */
        ORR     R8, R8, R5               /* Aplica Sg en PC2 */
        STR     R8, [R0]

        BX      LR

/* =========================================================================
   Subrutina: retardo
   Propósito: Temporizador por software (~1.6M ciclos de decremento).
   ========================================================================= */
retardo:
        LDR     R2, =1600000             /* Valor del contador para retardo */
loop_retardo:
        SUBS    R2, R2, #1               /* Resta 1 y actualiza la bandera Z */
        BNE     loop_retardo             /* Si R2 != 0 vuelve a iterar */
        BX      LR                       /* Retorna a la instrucción posterior a BL */

.size asm_main, .-asm_main

```