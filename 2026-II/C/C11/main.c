#include "stm32f7xx_hal.h"

// -----------------------------------------------------------------------------
// Definiciones de Hardware para NUCLEO-F429ZI
// -----------------------------------------------------------------------------
#define LED1_PORT         GPIOB
#define LED1_PIN          GPIO_PIN_0    // LD1 - Verde

#define LED2_PORT         GPIOB
#define LED2_PIN          GPIO_PIN_7    // LD2 - Azul

#define LED3_PORT         GPIOB
#define LED3_PIN          GPIO_PIN_14   // LD3 - Rojo

#define BUTTON_PORT       GPIOC
#define BUTTON_PIN        GPIO_PIN_13   // Pulsador de Usuario (User Button)

// -----------------------------------------------------------------------------
// Definición de Estados de la FSM
// -----------------------------------------------------------------------------
typedef enum {
    ESTADO_APAGADO = 0, // Todos los LEDs apagados
    ESTADO_VERDE,       // LED1 (Verde) Encendido
    ESTADO_AZUL,        // LED2 (Azul) Encendido
    ESTADO_ROJO,        // LED3 (Rojo) Encendido
    ESTADO_SECUENCIA    // Parpadeo/Secuencia alternativa
} EstadoFSM_t;

// Variable global de estado
static EstadoFSM_t estado_actual = ESTADO_APAGADO;

// Prototipos de funciones
void SystemClock_Config(void);
void MX_GPIO_Init(void);
void FSM_Actualizar(void);
uint8_t LeerPulsadorConAntirrebote(void);

// Handler de SysTick
void SysTick_Handler(void)
{
    HAL_IncTick();
}

// -----------------------------------------------------------------------------
// Función Principal
// -----------------------------------------------------------------------------
int main(void)
{
    HAL_Init();
    SystemClock_Config();
    MX_GPIO_Init();

    while (1)
    {
        // Ejecución continua no bloqueante de la máquina de estados
        FSM_Actualizar();
    }
}

// -----------------------------------------------------------------------------
// Lógica de la Máquina de Estados Finitos (FSM)
// -----------------------------------------------------------------------------
void FSM_Actualizar(void)
{
    // Verificar si se ha presionado el pulsador
    uint8_t pulsador_presionado = LeerPulsadorConAntirrebote();

    // Transiciones de estado por evento de pulsación
    if (pulsador_presionado)
    {
        switch (estado_actual)
        {
            case ESTADO_APAGADO:
                estado_actual = ESTADO_VERDE;
                break;

            case ESTADO_VERDE:
                estado_actual = ESTADO_AZUL;
                break;

            case ESTADO_AZUL:
                estado_actual = ESTADO_ROJO;
                break;

            case ESTADO_ROJO:
                estado_actual = ESTADO_SECUENCIA;
                break;

            case ESTADO_SECUENCIA:
                estado_actual = ESTADO_APAGADO;
                break;

            default:
                estado_actual = ESTADO_APAGADO;
                break;
        }
    }

    // Salidas/Acciones según el estado actual
    static uint32_t ultimo_tick = 0;
    uint32_t tick_actual = HAL_GetTick();
    static uint32_t contador = 0;

    switch (estado_actual)
    {
        case ESTADO_APAGADO:
            HAL_GPIO_WritePin(LED1_PORT, LED1_PIN, GPIO_PIN_RESET);
            HAL_GPIO_WritePin(LED2_PORT, LED2_PIN, GPIO_PIN_RESET);
            HAL_GPIO_WritePin(LED3_PORT, LED3_PIN, GPIO_PIN_RESET);
            break;

        case ESTADO_VERDE:
            HAL_GPIO_WritePin(LED1_PORT, LED1_PIN, GPIO_PIN_SET);
            HAL_GPIO_WritePin(LED2_PORT, LED2_PIN, GPIO_PIN_RESET);
            HAL_GPIO_WritePin(LED3_PORT, LED3_PIN, GPIO_PIN_RESET);
            break;

        case ESTADO_AZUL:
            HAL_GPIO_WritePin(LED1_PORT, LED1_PIN, GPIO_PIN_RESET);
            HAL_GPIO_WritePin(LED2_PORT, LED2_PIN, GPIO_PIN_SET);
            HAL_GPIO_WritePin(LED3_PORT, LED3_PIN, GPIO_PIN_RESET);
            break;

        case ESTADO_ROJO:
            HAL_GPIO_WritePin(LED1_PORT, LED1_PIN, GPIO_PIN_RESET);
            HAL_GPIO_WritePin(LED2_PORT, LED2_PIN, GPIO_PIN_RESET);
            HAL_GPIO_WritePin(LED3_PORT, LED3_PIN, GPIO_PIN_SET);
            break;

        case ESTADO_SECUENCIA:
            // Parpadeo no bloqueante alternado cada 200 ms
            if (tick_actual - ultimo_tick >= 200)
            {
                ultimo_tick = tick_actual;

                if(contador == 0)
                {
                	HAL_GPIO_WritePin(LED1_PORT, LED1_PIN, GPIO_PIN_SET);
                	HAL_GPIO_WritePin(LED2_PORT, LED2_PIN, GPIO_PIN_RESET);
                	HAL_GPIO_WritePin(LED3_PORT, LED3_PIN, GPIO_PIN_RESET);
                	contador++;
                }
                else if(contador == 1)
                {
                	HAL_GPIO_WritePin(LED1_PORT, LED1_PIN, GPIO_PIN_RESET);
                	HAL_GPIO_WritePin(LED2_PORT, LED2_PIN, GPIO_PIN_RESET);
                	HAL_GPIO_WritePin(LED3_PORT, LED3_PIN, GPIO_PIN_SET);
                	contador++;
                }
                else if(contador == 2)
                {
                	HAL_GPIO_WritePin(LED1_PORT, LED1_PIN, GPIO_PIN_RESET);
                	HAL_GPIO_WritePin(LED2_PORT, LED2_PIN, GPIO_PIN_SET);
                	HAL_GPIO_WritePin(LED3_PORT, LED3_PIN, GPIO_PIN_RESET);
                	contador = 0;
                }
            }
            break;
    }
}

// -----------------------------------------------------------------------------
// Lectura de Pulsador con Filtro Antirrebote (No Bloqueante)
// -----------------------------------------------------------------------------
uint8_t LeerPulsadorConAntirrebote(void)
{
    static uint32_t ultimo_tiempo = 0;
    static GPIO_PinState estado_anterior = GPIO_PIN_RESET;
    uint32_t tiempo_actual = HAL_GetTick();

    GPIO_PinState estado_pulsador = HAL_GPIO_ReadPin(BUTTON_PORT, BUTTON_PIN);

    // Detección de flanco de subida (al presionar) con retardo de 100 ms
    if (estado_pulsador == GPIO_PIN_SET && estado_anterior == GPIO_PIN_RESET)
    {
        if (tiempo_actual - ultimo_tiempo > 100)
        {
            ultimo_tiempo = tiempo_actual;
            estado_anterior = GPIO_PIN_SET;
            return 1; // Pulsación válida
        }
    }
    else if (estado_pulsador == GPIO_PIN_RESET)
    {
        estado_anterior = GPIO_PIN_RESET;
    }

    return 0; // Sin evento de pulsación
}

// -----------------------------------------------------------------------------
// Inicialización de GPIO
// -----------------------------------------------------------------------------
void MX_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    // Habilitar Relojes de los Puertos B y C
    __HAL_RCC_GPIOB_CLK_ENABLE();
    __HAL_RCC_GPIOC_CLK_ENABLE();

    // Configurar LEDs (PB0, PB7, PB14)
    GPIO_InitStruct.Pin = LED1_PIN | LED2_PIN | LED3_PIN;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

    // Apagar LEDs al inicio
    HAL_GPIO_WritePin(GPIOB, LED1_PIN | LED2_PIN | LED3_PIN, GPIO_PIN_RESET);

    // Configurar Pulsador de Usuario (PC13)
    GPIO_InitStruct.Pin = BUTTON_PIN;
    GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
    GPIO_InitStruct.Pull = GPIO_NOPULL; // Pull-down externo integrado en la tarjeta NUCLEO
    HAL_GPIO_Init(BUTTON_PORT, &GPIO_InitStruct);
}

// -----------------------------------------------------------------------------
// Configuración del Reloj del Sistema
// -----------------------------------------------------------------------------
void SystemClock_Config(void)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    __HAL_RCC_PWR_CLK_ENABLE();
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
    HAL_RCC_OscConfig(&RCC_OscInitStruct);

    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
                                | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

    HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0);
}
