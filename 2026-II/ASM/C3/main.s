/* ----------------------------------------------------------------------------
- Programa en Ensamblador ARM Cortex-M4 (Sintaxis Thumb-2)
- Demuestra la gestión de variables y arreglos en memoria RAM (.data):
-  1. Lectura/escritura de variables escalares en RAM (LDR, STR).
-  2. Operación aritmética escalar (suma = variableA + variableB).
-  3. Recorrido e indexación manual de arreglos mediante offset de memoria (R4).
-  4. Suma vectorial componente a componente (arregloC = arregloA + arregloB).
-  5. Control de flujo con comparación de límites (CMP) y saltos (BEQ, B).
- ---------------------------------------------------------------------------- */

/* --- Directivas del ensamblador GNU (GAS) --- */
.syntax unified      // Utiliza la sintaxis unificada de ARM (compatible con modo ARM y Thumb)
.cpu cortex-m4       // Define la arquitectura objetivo como ARM Cortex-M4
.thumb               // Genera instrucciones en modo Thumb / Thumb-2 (requerido en Cortex-M)

/* --- Declaración de visibilidad y tipo para el enlazador (Linker) --- */
.global asm_main            // Exporta la etiqueta asm_main para ser accesible desde el startup
.type   asm_main, %function // Define asm_main como función ejecutable (marca el bit LSB para modo Thumb)


/* ============================================================================
- SECCIÓN DE DATOS INICIALIZADOS (.data)
- Ubicada en la memoria SRAM; almacena variables y arreglos con valores iniciales.
- ============================================================================ */
.section .data

variableA:  .word   100            // Variable escalar de 32 bits (4 bytes) inicializada en 100
variableB:  .word   200            // Variable escalar de 32 bits (4 bytes) inicializada en 200
suma:       .word   0              // Variable escalar de 32 bits para almacenar la suma escalar
arregloA:   .word   10, 20, 30, 40 // Arreglo de 4 enteros de 32 bits (16 bytes totales en RAM)
arregloB:   .word   50, 60, 70, 80 // Arreglo de 4 enteros de 32 bits (16 bytes totales en RAM)
arregloC:   .word    0,  0,  0,  0 // Arreglo de destino para los resultados de la suma vectorial


/* ============================================================================
- SECCIÓN DE CÓDIGO FUENTE (.text)
- Contiene el código ejecutable del programa (almacenado en la memoria Flash).
- ============================================================================ */
.section .text       // Sección de código de programa

asm_main:

        MOV     R4, #0          // Inicializa el registro R4 en 0 (usado como desplazamiento/offset en bytes)

LOOP:

        // --------------------------------------------------------------------
        // 1. PRUEBA DE ESCRITURA Y LECTURA EN MEMORIA RAM (variableA)
        // --------------------------------------------------------------------
        LDR     R0, =variableA  // Carga en R0 la dirección de memoria de 'variableA'
        MOV     R1, #500        // Carga el valor entero 500 en el registro R1
        STR     R1, [R0]        // Escribe el contenido de R1 (500) en la dirección apuntada por R0

        LDR     R2, [R0]        // Lee el valor desde la RAM en la dirección de R0 y lo guarda en R2 (R2 = 500)

        MOV     R1, #1000       // Carga un nuevo valor entero (1000) en R1
        STR     R1, [R0]        // Sobrescribe en RAM el valor de 'variableA' con 1000

        LDR     R2, [R0]        // Vuelve a leer 'variableA' desde la RAM para confirmar el cambio (R2 = 1000)

        // --------------------------------------------------------------------
        // 2. OPERACIÓN ESCALAR: suma = variableA + variableB
        // --------------------------------------------------------------------
        LDR     R0, =variableA  // Carga en R0 la dirección de 'variableA'
        LDR     R1, [R0]        // Lee el valor actualizado de 'variableA' en R1 (R1 = 1000)

        LDR     R0, =variableB  // Carga en R0 la dirección de 'variableB'
        LDR     R2, [R0]        // Lee el valor de 'variableB' en R2 (R2 = 200)

        ADD     R3, R1, R2      // Realiza la suma escalar: R3 = R1 + R2 (1000 + 200 = 1200)

        LDR     R0, =suma       // Carga en R0 la dirección de la variable 'suma'
        STR     R3, [R0]        // Guarda el resultado (1200) en la posición de memoria de 'suma'

        // --------------------------------------------------------------------
        // 3. OPERACIÓN VECTORIAL: arregloC[i] = arregloA[i] + arregloB[i]
        // --------------------------------------------------------------------

        // --- Obtener elemento i de arregloA ---
        LDR     R0, =arregloA   // Carga en R0 la dirección base de 'arregloA'
        ADD     R0, R4          // Suma el offset acumulado R4: R0 = Dirección_Base + Offset
        LDR     R1, [R0]        // Lee el valor de arregloA[i] y lo deposita en R1

        // --- Obtener elemento i de arregloB ---
        LDR     R0, =arregloB   // Carga en R0 la dirección base de 'arregloB'
        ADD     R0, R4          // Suma el offset acumulado R4: R0 = Dirección_Base + Offset
        LDR     R2, [R0]        // Lee el valor de arregloB[i] y lo deposita en R2

        // --- Sumar ambos elementos ---
        ADD     R3, R1, R2      // Realiza la suma posición a posición: R3 = R1 + R2

        // --- Almacenar resultado en arregloC ---
        LDR     R0, =arregloC   // Carga en R0 la dirección base de 'arregloC'
        ADD     R0, R4          // Suma el offset acumulado R4: R0 = Dirección_Base + Offset
        STR     R3, [R0]        // Guarda el resultado (R3) en la posición correspondiente de 'arregloC'

        // --- Incremento de índice y control del bucle ---
        ADD     R4, #4          // Avanza el offset en 4 bytes (tamaño de un dato de 32 bits / .word)

        CMP     R4, #16         // Compara el desplazamiento acumulado con 16 (4 elementos * 4 bytes = 16 bytes)
        BEQ     LIMITE          // Si R4 == 16 (Z=1), procesó los 4 elementos y salta a LIMITE

        B       LOOP            // Si R4 < 16, salta incondicionalmente al inicio del bucle para la siguiente iteración

LIMITE:
        MOV     R4, #0          // Reinicia el registro de desplazamiento R4 a 0 para el siguiente ciclo

        // =========================================================================
        // BUCLE INFINITO DE SEGURIDAD
        // =========================================================================
        B       LOOP            // Salto incondicional al inicio del ciclo de ejecución principal

.size asm_main, .-asm_main     // Calcula y define formalmente el tamaño en bytes de la función asm_main
