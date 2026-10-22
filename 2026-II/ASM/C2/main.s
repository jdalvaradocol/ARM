/* ----------------------------------------------------------------------------
- Programa de prueba de instrucciones en Ensamblador ARM (Cortex-M4)
- Demuestra el uso de carga de literales, operaciones aritméticas,
- lógicas y de comparación (CMP, TEQ, TST) con saltos condicionales.
- ---------------------------------------------------------------------------- */

.syntax unified      // Utiliza la sintaxis unificada de ARM (compatible con ARM y Thumb)
.cpu cortex-m4       // Define la arquitectura objetivo como ARM Cortex-M4
.thumb               // Genera instrucciones en modo Thumb / Thumb-2

.global asm_main     // Exporta la etiqueta asm_main para que sea visible
.type   asm_main, %function // Define asm_main como una función ejecutable

.section .text       // Sección de código fuente (.text)

.equ    DATOA,  100  // Define una constante DATOA = 100 (aunque no se usa en este fragmento)

asm_main:
	MOV     R0, #0	        // Inicializa el registro R0 en 0

LOOP:
    // =========================================================================
    // 1. OPERACIÓN ARITMÉTICA Y COMPARACIÓN (CMP)
    // =========================================================================
	ADD     R0, #7          // Suma 7 al valor actual de R0 (R0 = R0 + 7)

	CMP		R0, #28         // Compara R0 con 28 (R0 - 28) y actualiza las banderas de estado
	BEQ		IGUAL_CMP       // Salta a IGUAL si R0 es exactamente 28 (Branch if Equal)[cite: 2]
	BGT		MAYOR_CMP		// Salta a MAYOR si R0 es estrictamente mayor a 28 (Branch if Greater Than)
	BLT		MENOR_CMP       // Salta a MENOR si R0 es menor a 28 (Branch if Less Than)

    // =========================================================================
    // 2. PRUEBA DE EQUIVALENCIA LÓGICA (TEQ)
    // =========================================================================
EJEMPLO_TEQ:
	TEQ		R0, #7			// Operación XOR bit a bit entre R0 y 7 (solo actualiza banderas, no guarda el resultado)
	BEQ		IGUAL_TEQ       // Salta a IGUAL_TEQ si el resultado fue 0 (es decir, R0 es idéntico a 7)[cite: 2]

    // =========================================================================
    // 3. PRUEBA DE BITS (TST)
    // =========================================================================
EJEMPLO_TST:
	MOV		R0, #4          // Sobrescribe R0 con el valor 4 (0100 en binario)

	TST		R0, #4			// Operación AND bit a bit entre R0 y 4 (0100 & 0100 = 0100)
	BNE		BIT_ES_UNO      // Salta si el resultado NO es cero (es decir, el bit 2 está en 1)[cite: 2]
	BEQ		BIT_ES_CERO     // Salta si el resultado es cero (el bit 2 está en 0)[cite: 2]

    // =========================================================================
    // BLOQUES DE ASIGNACIÓN Y RETORNO AL BUCLE
    // =========================================================================
BIT_ES_UNO:
	MOV		R2, #10         // Asigna 10 a R2 indicando que el bit estaba en 1
	B       LOOP            // Salto incondicional de regreso al inicio
	 
BIT_ES_CERO:
	MOV		R2, #20         // Asigna 20 a R2 indicando que el bit estaba en 0
	B       LOOP            // Salto incondicional de regreso al inicio
	
IGUAL_CMP:
	MOV		R1, #10         // Asigna 10 a R1 si R0 era 28
	B       EJEMPLO_TEQ     // Salta a la siguiente fase de pruebas

MAYOR_CMP:
	MOV		R1, #20         // Asigna 20 a R1 si R0 era mayor a 28
	B       EJEMPLO_TEQ

MENOR_CMP:
	MOV		R1, #30         // Asigna 30 a R1 si R0 era menor a 28 (En la primera iteración caerá aquí)
	B       EJEMPLO_TEQ

IGUAL_TEQ:
	MOV		R1, #10         // Asigna 10 a R1 porque R0 es igual a 7
	B       EJEMPLO_TST     // CORREGIDO: Antes decía 'PASEJEMPLO_TST' (etiqueta inexistente)

    // =========================================================================
    // BUCLE INFINITO DE SEGURIDAD
    // =========================================================================
    B       LOOP            // Salto incondicional de respaldo[cite: 2]

.size asm_main, .-asm_main  // Calcula y establece el tamaño de la función
