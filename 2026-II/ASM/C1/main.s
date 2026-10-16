/* ----------------------------------------------------------------------------
 * Programa de prueba de instrucciones en Ensamblador ARM (Cortex-M4)
 * Demuestra el uso de carga de literales, operaciones aritméticas (ADD, ADC, ADDW),
 * lógicas (AND), desplazamientos (ASR, LSR) y carga de valores inmediatos (MOVW/MOVT).
 * ---------------------------------------------------------------------------- */

.syntax unified      // Utiliza la sintaxis unificada de ARM (compatible con ARM y Thumb)
.cpu cortex-m4       // Define la arquitectura objetivo como ARM Cortex-M4
.thumb               // Genera instrucciones en modo Thumb / Thumb-2

.global asm_main     // Exporta la etiqueta asm_main para que sea visible por el linker/C
.type   asm_main, %function // Define asm_main como una función

.section .text       // Sección de código fuente (.text)

// --- Definición de constantes numéricas (.equ) ---
.equ    DATOA,  100
.equ    DATOB,  200
.equ    DATOC,  300
.equ    DATOD,  4090
.equ    DATOE,  0
.equ    DATOF,  0x12345678

asm_main:

LOOP:
    // =========================================================================
    // 1. CARGA DE CONSTANTES INICIALES
    // =========================================================================
    LDR     R0, =DATOA      // Carga el valor 100 en R0
    LDR     R1, =DATOB      // Carga el valor 200 en R1
    LDR     R2, =DATOC      // Carga el valor 300 en R2

    // =========================================================================
    // 2. OPERACIONES CON ACARREO (ADC - Add with Carry)
    // Nota: Suma los operandos MÁS el bit de acarreo (C) del registro APSR.
    // =========================================================================
    ADC     R3, R1, R2      // R3 = R1 + R2 + C  (R3 = 200 + 300 + C = 500 + C)
    ADC     R2, R1          // R2 = R2 + R1 + C  (Forma corta: destino es el primer operando)
    ADC     R3, #100        // R3 = R3 + 100 + C

    // =========================================================================
    // 3. REINICIALIZACIÓN DE REGISTROS
    // =========================================================================
    LDR     R0, =DATOA      // R0 = 100
    LDR     R1, =DATOB      // R1 = 200
    LDR     R2, =DATOC      // R2 = 300

    // =========================================================================
    // 4. OPERACIONES DE SUMA ESTÁNDAR (ADD)
    // Nota: Suma simple sin tomar en cuenta el acarreo previo.
    // =========================================================================
    ADD     R3, R1, R2      // R3 = R1 + R2  (R3 = 200 + 300 = 500)
    ADD     R2, R1          // R2 = R2 + R1  (R2 = 300 + 200 = 500)
    ADD     R3, #100        // R3 = R3 + 100 (R3 = 500 + 100 = 600)

    // =========================================================================
    // 5. SUMA CON INMEDIATO ANCHO (ADDW - Add Wide)
    // Permite sumar valores inmediatos de hasta 12 bits (0 a 4095).
    // =========================================================================
    LDR     R4, =DATOD      // R4 = 4090
    ADDW    R6, R4, #4095   // R6 = R4 + 4095 (R6 = 4090 + 4095 = 8185)

    // =========================================================================
    // 6. OPERACIÓN LÓGICA
    // =========================================================================
    AND     R7, R1, R2      // R7 = R1 AND R2 (Operación Bitwise entre R1 y R2)

    // =========================================================================
    // 7. DESPLAZAMIENTOS DE BITS (Shift Operations)
    // =========================================================================
    LDR     R0, =DATOF      // R0 = 0x12345678

    // Desplazamiento aritmético a la derecha: conserva el signo (Bit 31)
    ASR     R9, R0, #4      // R9 = R0 >> 4  (R9 = 0x01234567)

    // Desplazamiento lógico a la derecha: rellena con ceros a la izquierda
    LSR     R10, R0, #4     // R10 = R0 >> 4 (R10 = 0x01234567)

    // =========================================================================
    // 8. MANEJO Y CARGA DE REGISTROS DE 32 BITS
    // =========================================================================
    LDR     R0, =DATOF      // Sobrescribe R0 con 0x12345678

    MOV     R0, #0xFFFF     // Carga 0x0000FFFF en R0 (Limpia la parte alta)

    // Carga de una constante de 32 bits dividida en dos instrucciones:
    MOVW    R0, #0x5678     // Carga los 16 bits bajos: R0 = 0x00005678
    MOVT    R0, #0x1234     // Carga los 16 bits altos: R0 = 0x12345678

    // =========================================================================
    // 9. BUCLE INFINITO
    // =========================================================================
    B       LOOP            // Salto incondicional al inicio (B = Branch)

.size asm_main, .-asm_main  // Calcula y establece el tamaño de la función
