```assembly
/*
 * main.s - Control de LEDs, multiplexación de display de 2 dígitos (00-99), 
 *          lectura de interruptores y procesamiento de botón en ensamblador puro
 * Tarjeta: NUCLEO-F429ZI (Cortex-M4)
 * Microcontrolador: STM32F429ZIT6
 * Periféricos: 
 *   - LEDs de tarjeta: LED1 (Verde) en PB0, LED2 (Azul) en PB7
 *   - Botón B1 (Usuario) en PC13
 *   - Entradas digitales (SW0..SW3): PF13, PE9, PE11, PF14
 *   - Salidas digitales a LEDs externos (LED0..LED3): PE8, PE7, PE10, PE12
 *   - Display de 7 Segmentos:
 *       Sa->PD11, Sb->PD13, Sc->PF4, Sd->PB6, Se->PB2, Sf->PD12, Sg->PC2
 *       Habilitación Dígito D0 (Decenas) -> PF12
 *       Habilitación Dígito D1 (Unidades) -> PD15
 */

.syntax unified              /* Utiliza la sintaxis unificada de ARM Cortex */
.cpu cortex-m4               /* Define la arquitectura del procesador objetivo */
.thumb                       /* Genera instrucciones en el conjunto Thumb-2 */

.global     asm_main         /* Exporta el símbolo asm_main para el enlazador (linker) */
.type       asm_main, %function

.section .text               /* Define la sección de código de solo lectura */

/* =========================================================================
   Mapa de Direcciones de Memoria MMIO (Memory-Mapped I/O)
   ========================================================================= */

/* Reloj RCC (Reset and Clock Control) */
.equ RCC_BASE,        0x40023800
.equ RCC_AHB1ENR,     (RCC_BASE + 0x30)   /* Registro de habilitación de reloj del bus AHB1 */

/* Registros GPIO del Puerto A */
.equ GPIOA_BASE,      0x40020000
.equ GPIOA_MODER,     (GPIOA_BASE + 0x00) /* Registro de modo (Entrada/Salida/Alt/Analógico) */
.equ GPIOA_IDR,       (GPIOA_BASE + 0x10) /* Registro de datos de entrada */
.equ GPIOA_ODR,       (GPIOA_BASE + 0x14) /* Registro de datos de salida */

/* Registros GPIO del Puerto B */
.equ GPIOB_BASE,      0x40020400
.equ GPIOB_MODER,     (GPIOB_BASE + 0x00) 
.equ GPIOB_IDR,       (GPIOB_BASE + 0x10) 
.equ GPIOB_ODR,       (GPIOB_BASE + 0x14) 

/* Registros GPIO del Puerto C */
.equ GPIOC_BASE,      0x40020800
.equ GPIOC_MODER,     (GPIOC_BASE + 0x00) 
.equ GPIOC_IDR,       (GPIOC_BASE + 0x10) 
.equ GPIOC_ODR,       (GPIOC_BASE + 0x14) 

/* Registros GPIO del Puerto D */
.equ GPIOD_BASE,      0x40020C00
.equ GPIOD_MODER,     (GPIOD_BASE + 0x00) 
.equ GPIOD_IDR,       (GPIOD_BASE + 0x10) 
.equ GPIOD_ODR,       (GPIOD_BASE + 0x14) 

/* Registros GPIO del Puerto E */
.equ GPIOE_BASE,      0x40021000
.equ GPIOE_MODER,     (GPIOE_BASE + 0x00) 
.equ GPIOE_IDR,       (GPIOE_BASE + 0x10) 
.equ GPIOE_ODR,       (GPIOE_BASE + 0x14) 

/* Registros GPIO del Puerto F */
.equ GPIOF_BASE,      0x40021400
.equ GPIOF_MODER,     (GPIOF_BASE + 0x00) 
.equ GPIOF_IDR,       (GPIOF_BASE + 0x10) 
.equ GPIOF_ODR,       (GPIOF_BASE + 0x14) 

/* =========================================================================
   Punto de Entrada del Programa (asm_main)
   ========================================================================= */
asm_main:

    /* ---------------------------------------------------------------------
       1. Habilitación de Relojes Periféricos (RCC_AHB1ENR)
       --------------------------------------------------------------------- */
        LDR     R0, =RCC_AHB1ENR         /* Carga la dirección del registro AHB1ENR en R0 */
        LDR     R1, [R0]                 /* Lee el contenido actual del registro en R1 */
        ORR     R1, R1, #(1 << 0)        /* Activa el reloj para GPIOA (Bit 0) */
        ORR     R1, R1, #(1 << 1)        /* Activa el reloj para GPIOB (Bit 1) */
        ORR     R1, R1, #(1 << 2)        /* Activa el reloj para GPIOC (Bit 2) */
        ORR     R1, R1, #(1 << 3)        /* Activa el reloj para GPIOD (Bit 3) */
        ORR     R1, R1, #(1 << 4)        /* Activa el reloj para GPIOE (Bit 4) */
        ORR     R1, R1, #(1 << 5)        /* Activa el reloj para GPIOF (Bit 5) */
        STR     R1, [R0]                 /* Escribe la configuración de vuelta en RCC_AHB1ENR */

    /* ---------------------------------------------------------------------
       2. Configuración de Modos GPIO (GPIOB)
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOB_MODER         /* Carga la dirección de GPIOB_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 14)       /* Limpia bits 15:14 (Configura PB7) */
        ORR     R1, R1, #(1 << 14)       /* Asigna modo Salida ('01') en bits 15:14 */
        STR     R1, [R0]

        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 0)        /* Limpia bits 1:0 (PB0 - LED1) */
        ORR     R1, R1, #(1 << 0)        /* Asigna modo Salida ('01') en bits 1:0 */
        STR     R1, [R0]

        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 14)       /* Limpia bits 15:14 (PB7 - LED2) */
        ORR     R1, R1, #(1 << 14)       /* Asigna modo Salida ('01') en bits 15:14 */
        STR     R1, [R0]

        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 2)        /* Limpia bits 3:2 (PB1 - DP) */
        BIC     R1, R1, #(3 << 4)        /* Limpia bits 5:4 (PB2 - SE) */
        BIC     R1, R1, #(3 << 12)       /* Limpia bits 13:12 (PB6 - SD) */
        ORR     R1, R1, #(1 << 2)        /* Configura PB1 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 4)        /* Configura PB2 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 12)       /* Configura PB6 en modo Salida ('01') */
        STR     R1, [R0]                 /* Escribe la configuración en GPIOB_MODER */

    /* ---------------------------------------------------------------------
       3. Configuración de Modos GPIO (GPIOC)
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOC_MODER         /* Apunta a GPIOC_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 4)        /* Limpia bits 5:4 (PC2 - SG) */
        BIC     R1, R1, #(3 << 26)       /* Limpia bits 27:26 (PC13 - Botón B1 en modo Entrada '00') */
        ORR     R1, R1, #(1 << 4)        /* Configura PC2 en modo Salida ('01') */
        STR     R1, [R0]

    /* ---------------------------------------------------------------------
       4. Configuración de Modos GPIO (GPIOD)
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOD_MODER         /* Apunta a GPIOD_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 22)       /* Limpia bits de PD11 (Sa) */
        BIC     R1, R1, #(3 << 24)       /* Limpia bits de PD12 (Sf) */
        BIC     R1, R1, #(3 << 26)       /* Limpia bits de PD13 (Sb) */
        BIC     R1, R1, #(3 << 28)       /* Limpia bits de PD14 (D2) */
        BIC     R1, R1, #(3 << 30)       /* Limpia bits de PD15 (D1) */
        ORR     R1, R1, #(1 << 22)       /* Configura PD11 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 24)       /* Configura PD12 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 26)       /* Configura PD13 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 28)       /* Configura PD14 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 30)       /* Configura PD15 en modo Salida ('01') */
        STR     R1, [R0]

    /* ---------------------------------------------------------------------
       5. Configuración de Modos GPIO (GPIOE)
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOE_MODER         /* Apunta a GPIOE_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 14)       /* Limpia PE7  */
        BIC     R1, R1, #(3 << 16)       /* Limpia PE8  */
        BIC     R1, R1, #(3 << 18)       /* Limpia PE9  (Configurado como Entrada '00') */
        BIC     R1, R1, #(3 << 20)       /* Limpia PE10 */
        BIC     R1, R1, #(3 << 22)       /* Limpia PE11 (Configurado como Entrada '00') */
        BIC     R1, R1, #(3 << 24)       /* Limpia PE12 */
        
        ORR     R1, R1, #(1 << 14)       /* Configura PE7 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 16)       /* Configura PE8 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 20)       /* Configura PE10 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 24)       /* Configura PE12 en modo Salida ('01') */
        STR     R1, [R0]

    /* ---------------------------------------------------------------------
       6. Configuración de Modos GPIO (GPIOF)
       --------------------------------------------------------------------- */
        LDR     R0, =GPIOF_MODER         /* Apunta a GPIOF_MODER */
        LDR     R1, [R0]
        BIC     R1, R1, #(3 << 8)        /* Limpia PF4  (Sc) */
        BIC     R1, R1, #(3 << 24)       /* Limpia PF12 (D0) */
        BIC     R1, R1, #(3 << 26)       /* Limpia PF13 (Configurado como Entrada '00') */
        BIC     R1, R1, #(3 << 28)       /* Limpia PF14 (Configurado como Entrada '00') */
        ORR     R1, R1, #(1 << 8)        /* Configura PF4 en modo Salida ('01') */
        ORR     R1, R1, #(1 << 24)       /* Configura PF12 en modo Salida ('01') */
        STR     R1, [R0]

    /* Inicialización de Variables del Contador de 2 Dígitos */
        MOV     R11, #0                  /* R11 = Contador de Unidades (0..9) */
        MOV     R12, #0                  /* R12 = Contador de Decenas (0..9) */

/* =========================================================================
   Bucle Principal del Programa
   ========================================================================= */
bucle_principal:

        MOV     R10, #50                 /* R10 = 50 ciclos de refresco (~200ms por incremento) */
        
loop_display:

    /* Muestra Dígito de Decenas (D0 en PF12) */
        MOV     R3, R12                  /* Carga decenas en R3 para decodificar */
        BL      decimal_segmentos        /* Genera mapa de 7 segmentos en R1 */
        BL      display_salida           /* Aplica estados a los pines de segmentos */

        /* Habilita dígito D0 (PF12 = 1) */
        LDR     R0, =GPIOF_ODR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 12)       /* Enciende PF12 (Activa común de D0) */
        STR     R1, [R0]

        /* Deshabilita dígito D1 (PD15 = 0) */
        LDR     R0, =GPIOD_ODR
        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 15)       /* Apaga PD15 (Desactiva común de D1) */
        STR     R1, [R0]

        MOV     R1, #2                   /* Carga retardo de 2 ms */
        BL      retardo_ms               /* Tiempo de encendido del dígito D0 */

    /* Muestra Dígito de Unidades (D1 en PD15) */
        MOV     R3, R11                  /* Carga unidades en R3 para decodificar */
        BL      decimal_segmentos        /* Genera mapa de 7 segmentos en R1 */
        BL      display_salida           /* Aplica estados a los pines de segmentos */

        /* Deshabilita dígito D0 (PF12 = 0) */
        LDR     R0, =GPIOF_ODR
        LDR     R1, [R0]
        BIC     R1, R1, #(1 << 12)       /* Apaga PF12 (Desactiva común de D0) */
        STR     R1, [R0]

        /* Habilita dígito D1 (PD15 = 1) */
        LDR     R0, =GPIOD_ODR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 15)       /* Enciende PD15 (Activa común de D1) */
        STR     R1, [R0]

        MOV     R1, #2                   /* Carga retardo de 2 ms */
        BL      retardo_ms               /* Tiempo de encendido del dígito D1 */

        SUBS    R10, R10, #1             /* Decrementa el contador de refresco */
        BNE     loop_display             /* Repite bucle hasta completar los 50 ciclos */

    /* Lógica de Incremento del Contador de 2 Dígitos (00 a 99) */
        ADD     R11, #1                  /* Incrementa Unidades (R11 = R11 + 1) */
        CMP     R11, #10                 /* ¿Llegó a 10 las unidades? */
        BEQ     siU10                    /* Si es 10, salta a reiniciar unidades e incrementar decenas */
        BNE     no10                     /* Si no es 10, continúa con las tareas secundarias */

siU10:
        MOV     R11, #0                  /* Reinicia unidades a 0 */
        ADD     R12, #1                  /* Incrementa Decenas (R12 = R12 + 1) */
        CMP     R12, #10                 /* ¿Llegaron a 10 las decenas? */
        BEQ     siD10                    /* Si es 10, salta a reiniciar decenas */
        BNE     no10                     /* Si no es 10, continúa */

siD10:
        MOV     R12, #0                  /* Reinicia decenas a 0 (reinicio completo a 00) */

no10:
        BL      leer_entrada             /* Lee el estado de los interruptores externos (SW0..SW3) */
        BL      escribir_salida          /* Escribe los estados en los LEDs externos (PE8, PE7, PE10, PE12) */

        /* Comprobación de estado del Botón B1 (PC13) */
        LDR     R0, =GPIOC_IDR           /* Carga el registro de entradas de GPIOC */
        LDR     R1, [R0]                 /* Lee los pines de entrada del Puerto C */
        
        TST     R1, #(1 << 13)           /* Evalúa el bit 13 (Botón B1) */
        BNE     rutina_true              /* Si Bit 13 != 0 (Presionado / ALTO) salta a rutina_true */
        BEQ     rutina_false             /* Si Bit 13 == 0 (No presionado / BAJO) salta a rutina_false */

        B       bucle_principal          /* Regresa al inicio del bucle principal */

/* =========================================================================
   Subrutina: decimal_segmentos
   Propósito: Recibe en R3 un valor entero entre 0 y 9 y genera en R1 la
              máscara de encendido para un display de 7 segmentos.
   ========================================================================= */
decimal_segmentos:
        CMP     R3, #0                   /* ¿El valor en R3 es 0? */
        BEQ     digitocero
        CMP     R3, #1                   /* ¿El valor en R3 es 1? */
        BEQ     digitouno
        CMP     R3, #2                   /* ¿El valor en R3 es 2? */
        BEQ     digitodos
        CMP     R3, #3                   /* ¿El valor en R3 es 3? */
        BEQ     digitotres
        CMP     R3, #4                   /* ¿El valor en R3 es 4? */
        BEQ     digitocuatro
        CMP     R3, #5                   /* ¿El valor en R3 es 5? */
        BEQ     digitocinco
        CMP     R3, #6                   /* ¿El valor en R3 es 6? */
        BEQ     digitoseis
        CMP     R3, #7                   /* ¿El valor en R3 es 7? */
        BEQ     digitosiete
        CMP     R3, #8                   /* ¿El valor en R3 es 8? */
        BEQ     digitoocho
        CMP     R3, #9                   /* ¿El valor en R3 es 9? */
        BEQ     digitonueve

        MOV     R1, #0                   /* Si R3 > 9 o inválido, apaga todos los segmentos */
        BX      LR                       /* Retorno de subrutina */

digitocero:
        MOV     R1, #0xBF                /* 0b10111111 -> Activa segmentos A, B, C, D, E, F */
        BX      LR

digitouno:
        MOV     R1, #0x86                /* 0b10000110 -> Activa segmentos B, C */
        BX      LR

digitodos:
        MOV     R1, #0xDB                /* 0b11011011 -> Activa segmentos A, B, D, E, G */
        BX      LR

digitotres:
        MOV     R1, #0xCF                /* 0b11001111 -> Activa segmentos A, B, C, D, G */
        BX      LR

digitocuatro:
        MOV     R1, #0xE6                /* 0b11100110 -> Activa segmentos B, C, F, G */
        BX      LR

digitocinco:
        MOV     R1, #0xED                /* 0b11101101 -> Activa segmentos A, C, D, F, G */
        BX      LR

digitoseis:
        MOV     R1, #0xFD                /* 0b11111101 -> Activa segmentos A, C, D, E, F, G */
        BX      LR

digitosiete:
        MOV     R1, #0x87                /* 0b10000111 -> Activa segmentos A, B, C */
        BX      LR

digitoocho:
        MOV     R1, #0xFF                /* 0b11111111 -> Activa todos los segmentos (A..G + punto) */
        BX      LR

digitonueve:
        MOV     R1, #0xEF                /* 0b11101111 -> Activa segmentos A, B, C, D, F, G */
        BX      LR

/* -------------------------------------------------------------------------
   Rutina: rutina_true (Ejecutada cuando el botón PC13 está en ALTO)
   Acción: Conmuta/invierte (Toggle) el estado del LED1 (PB0/PB1)
   ------------------------------------------------------------------------- */
rutina_true:
        LDR     R0, =GPIOB_ODR
        LDR     R1, [R0]
        EOR     R1, R1, #(1 << 1)        /* Conmuta el bit 1 de GPIOB_ODR */
        STR     R1, [R0]

        B       bucle_principal          /* Regresa al ciclo principal */

/* -------------------------------------------------------------------------
   Rutina: rutina_false (Ejecutada cuando el botón PC13 está en BAJO)
   Acción: Conmuta/invierte (Toggle) el estado del LED2 (PB7)
   ------------------------------------------------------------------------- */
rutina_false:
        LDR     R0, =GPIOB_ODR
        LDR     R1, [R0]
        EOR     R1, R1, #(1 << 7)        /* Conmuta el bit 7 (PB7) de GPIOB_ODR */
        STR     R1, [R0]
        
        B       bucle_principal          /* Regresa al ciclo principal */

/* =========================================================================
   Subrutina: leer_entrada
   Propósito: Lee los pines de entrada (SW0..SW3) y empaqueta sus valores
              en los 4 bits menos significativos del registro R3 [SW3,SW2,SW1,SW0].
   ========================================================================= */
leer_entrada:
        LDR     R0, =GPIOE_IDR           /* Lectura de entradas en puerto E */
        LDR     R1, [R0]

        // PE11 (SW2) -> Aislar bit 11 y mover a bit 2 (desplazamiento a la derecha 9 bits)
        AND     R2, R1, #(1 << 11)
        LSR     R3, R2, #9

        // PE9 (SW1) -> Aislar bit 9 y mover a bit 1 (desplazamiento a la derecha 8 bits)
        AND     R2, R1, #(1 << 9)
        LSR     R4, R2, #8

        LDR     R0, =GPIOF_IDR           /* Lectura de entradas en puerto F */
        LDR     R1, [R0] 

        // PF13 (SW0) -> Aislar bit 13 y mover a bit 0 (desplazamiento a la derecha 13 bits)
        AND     R2, R1, #(1 << 13)
        LSR     R5, R2, #13

        // PF14 (SW3) -> Aislar bit 14 y mover a bit 3 (desplazamiento a la derecha 11 bits)
        AND     R2, R1, #(1 << 14)
        LSR     R6, R2, #11

        /* Empaqueta los bits procesados en R3 acumulando los resultados */
        ORR     R3, R3, R4
        ORR     R3, R3, R5
        ORR     R3, R3, R6

        BX      LR                       /* Retorno de subrutina */

/* =========================================================================
   Subrutina: escribir_salida
   Propósito: Toma los 4 bits del registro R3 y los desplaza a las posiciones
              correspondientes de los pines GPIOE (PE8, PE7, PE10, PE12).
   ========================================================================= */
escribir_salida:

        // Bit 0 de R3 -> Mapear a PE8 (LED0)
        AND     R4, R3, #(1 << 0)
        LSL     R4, R4, #8

        // Bit 1 de R3 -> Mapear a PE7 (LED1)
        AND     R5, R3, #(1 << 1)
        LSL     R5, R5, #6

        // Bit 2 de R3 -> Mapear a PE10 (LED2)
        AND     R6, R3, #(1 << 2)
        LSL     R6, R6, #8

        // Bit 3 de R3 -> Mapear a PE12 (LED3)
        AND     R7, R3, #(1 << 3)
        LSL     R7, R7, #9

        /* Combina todas las máscaras preparadas */
        ORR     R4, R4, R5
        ORR     R4, R4, R6
        ORR     R4, R4, R7

        LDR     R0, =GPIOE_ODR           /* Apunta al registro de salida de GPIOE */
        LDR     R1, [R0]
        STR     R4, [R0]                 /* Escribe la palabra resultante en el registro ODR */

        BX      LR                       /* Retorno de subrutina */

/* =========================================================================
   Subrutina: display_salida
   Propósito: Toma los bits codificados de R1 (formato 7 segmentos) y los
              escribe en los pines GPIO correspondientes (GPIOD, GPIOF, GPIOB, GPIOC).
   ========================================================================= */
display_salida:

        // Bit 0 de R1 (Sa) -> Mapear a PD11 (desplazar 11 bits a la izquierda)
        AND     R4, R1, #(1 << 0)
        LSL     R5, R4, #11

        // Bit 1 de R1 (Sb) -> Mapear a PD13 (desplazar 12 bits a la izquierda desde bit 1)
        AND     R4, R1, #(1 << 1)
        LSL     R6, R4, #12

        // Bit 5 de R1 (Sf) -> Mapear a PD12 (desplazar 7 bits a la izquierda desde bit 5)
        AND     R4, R1, #(1 << 5)
        LSL     R7, R4, #7

        /* Limpia y actualiza los pines PD11, PD12 y PD13 en GPIOD */
        LDR     R0, =GPIOD_ODR           /* Apunta al registro de salida GPIOD_ODR */
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 11)       /* Limpia bit 11 (PD11) */
        BIC     R8, R8, #(1 << 12)       /* Limpia bit 12 (PD12) */
        BIC     R8, R8, #(1 << 13)       /* Limpia bit 13 (PD13) */
        ORR     R8, R8, R5               /* Aplica estado de Sa (PD11) */
        ORR     R8, R8, R6               /* Aplica estado de Sb (PD13) */
        ORR     R8, R8, R7               /* Aplica estado de Sf (PD12) */
        STR     R8, [R0]                 /* Actualiza GPIOD_ODR */

        // Bit 2 de R1 (Sc) -> Mapear a PF4 (desplazar 2 bits a la izquierda)
        AND     R4, R1, #(1 << 2)
        LSL     R5, R4, #2

        /* Limpia y actualiza el pin PF4 en GPIOF */
        LDR     R0, =GPIOF_ODR           /* Apunta al registro de salida GPIOF_ODR */
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 4)        /* Limpia bit 4 (PF4) */
        ORR     R8, R8, R5               /* Aplica estado de Sc (PF4) */
        STR     R8, [R0]                 /* Actualiza GPIOF_ODR */

        // Bit 3 de R1 (Sd) -> Mapear a PB6 (desplazar 3 bits a la izquierda)
        AND     R4, R1, #(1 << 3)
        LSL     R5, R4, #3

        // Bit 4 de R1 (Se) -> Mapear a PB2 (desplazar 2 bits a la derecha)
        AND     R4, R1, #(1 << 4)
        LSR     R6, R4, #2

        /* Limpia y actualiza los pines PB2 y PB6 en GPIOB */
        LDR     R0, =GPIOB_ODR           /* Apunta al registro de salida GPIOB_ODR */
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 2)        /* Limpia bit 2 (PB2) */
        BIC     R8, R8, #(1 << 6)        /* Limpia bit 6 (PB6) */
        ORR     R8, R8, R5               /* Aplica estado de Sd (PB6) */
        ORR     R8, R8, R6               /* Aplica estado de Se (PB2) */
        STR     R8, [R0]                 /* Actualiza GPIOB_ODR */

        // Bit 6 de R1 (Sg) -> Mapear a PC2 (desplazar 4 bits a la derecha)
        AND     R4, R1, #(1 << 6)
        LSR     R5, R4, #4

        /* Limpia y actualiza el pin PC2 en GPIOC */
        LDR     R0, =GPIOC_ODR           /* Apunta al registro de salida GPIOC_ODR */
        LDR     R8, [R0]
        BIC     R8, R8, #(1 << 2)        /* Limpia bit 2 (PC2) */
        ORR     R8, R8, R5               /* Aplica estado de Sg (PC2) */
        STR     R8, [R0]                 /* Actualiza GPIOC_ODR */

        BX      LR                       /* Retorno de subrutina */

/* =========================================================================
   Subrutina: retardo_ms
   Propósito: Genera una retardo en milisegundos basado en el valor ingresado en R1.
   ========================================================================= */
retardo_ms:
        SUBS    R1, R1, #1               /* Decrementa el valor en R1 (cantidad de ms) */
        BNE     loop_retardoA            /* Si R1 > 0, inicia iteración de 1 milisegundo */
        BX      LR                       /* Si R1 == 0, retorna a la rutina llamadora */

loop_retardoA:
        LDR     R2, =16000               /* Contador para ~1 ms a frecuencia por defecto de 16 MHz */
loop_retardoB:
        SUBS    R2, R2, #1               /* Decrementa R2 en 1 */
        BNE     loop_retardoB            /* Continúa en bucle interno hasta que R2 == 0 */
        B       retardo_ms               /* Evalúa de nuevo la cantidad de ms restantes en R1 */

.size asm_main, .-asm_main

```