#include "stm32f4xx_hal.h"
#include "ST7920_parallel.h"
#include "animacion.h"
#include <stdio.h>

void SysTick_Handler(void)
{
	HAL_IncTick();
}

void SystemClock_Config(void);
void MX_GPIO_Init(void);

int main(void)
{
    HAL_Init();
    SystemClock_Config();
    MX_GPIO_Init();

    // 1. Inicializar pantalla ST7920
    ST7920_Init();

    // -------------------------------------------------------------
    // ETAPA 1: Dibujo de Primitivas Geométricas (Círculos y Rectángulo)
    // -------------------------------------------------------------
    ST7920_GraphicMode(1);
    ST7920_ClearBuffer();

    // Marco exterior de la pantalla (128x64)
    DrawRectangle(0, 0, 127, 63);

    // Círculo a la izquierda
    DrawCircle(32, 32, 18);

    // Rectángulo relleno a la derecha
    DrawFilledRectangle(65, 18, 50, 28);

    // Renderizar buffer en la pantalla y esperar 3 segundos
    ST7920_Update();
    HAL_Delay(3000);

    // -------------------------------------------------------------
	// ETAPA 2: Reproducción del GIF Invertido (10 Repeticiones)
	// -------------------------------------------------------------
	uint8_t frame_invertido[1024];

	for (int rep = 0; rep < 10; rep++)
	{
		for (int i = 0; i < GIF_TOTAL_FRAMES; i++)
		{
			// 1. Invertir byte a byte el frame actual de la Flash hacia la RAM
			for (int b = 0; b < 1024; b++)
			{
				frame_invertido[b] = ~gif_frames[i][b];
			}

			// 2. Pasar la dirección del arreglo completo (sin corchetes [i])
			ST7920_DrawBitmap(frame_invertido);
			HAL_Delay(100);
		}
	}

    // -------------------------------------------------------------
    // ETAPA 3: Modo Texto con Contador Dinámico
    // -------------------------------------------------------------
    // Desactivar modo gráfico y limpiar pantalla
    ST7920_GraphicMode(0);
    ST7920_Clear();

    // Mensaje Estático Inicial
    ST7920_SendString(0, 0, "ANIMACION OK!");
    ST7920_SendString(1, 0, "SISTEMA LISTO");
    ST7920_SendString(2, 0, "ESTADO: ACTIVO");

    // Variables para el contador
    uint32_t contador = 0;
    char buffer_count[17];

    while (1)
    {
        // Formatear y actualizar únicamente la Fila 3
        snprintf(buffer_count, sizeof(buffer_count), "CONTEO: %05lu", contador);
        ST7920_SendString(3, 0, buffer_count);

        contador++;
        HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0); // Toggle LED verde NUCLEO
        HAL_Delay(500);
    }
}

void MX_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    // Habilitar Relojes de GPIOB, GPIOC y GPIOD
    __HAL_RCC_GPIOB_CLK_ENABLE();
    __HAL_RCC_GPIOC_CLK_ENABLE();
    __HAL_RCC_GPIOD_CLK_ENABLE();

    // Configurar Puerto C: RS (PC9), RW (PC10), E (PC11)
    GPIO_InitStruct.Pin = RS_PIN | RW_PIN | E_PIN;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_MEDIUM;
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

    // Configurar Puerto D: RST (PD3), DB7 (PD4), DB6 (PD5), DB5 (PD6), DB4 (PD7)
    GPIO_InitStruct.Pin = RST_PIN | GPIO_PIN_4 | GPIO_PIN_5 | GPIO_PIN_6 | GPIO_PIN_7;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_MEDIUM;
    HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

    // LED verde de estado (PB0)
    GPIO_InitStruct.Pin = GPIO_PIN_0;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
}

void SystemClock_Config(void)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    __HAL_RCC_PWR_CLK_ENABLE();
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    // Configuración HSI a 16 MHz sin PLL
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE; // PLL APAGADO
    HAL_RCC_OscConfig(&RCC_OscInitStruct);

    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                                |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

    // Latencia 0 para 16 MHz
    HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0);
}
