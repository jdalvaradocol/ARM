#include "stm32f4xx_hal.h"
#include "ST7920_parallel.h"
#include "animacion.h"
#include "teclado.h"
#include <stdio.h>

#define COLUMNA1    127
#define COLUMNA2    255
#define COLUMNA3    383
#define COLUMNA4    511
#define COLUMNA5    639
#define COLUMNA6    767
#define COLUMNA7    895
#define COLUMNA8    1023 

void SysTick_Handler(void)
{
	HAL_IncTick();
}

void SystemClock_Config(void);
void MX_GPIO_Init(void);

int main(void)
{

	// Variables para visluzalr el mensaje y guardar la tecla ingresada.
	char buffer_count[17];
	uint8_t tecla = 0;
    uint8_t IM1[1024] = frame_0;
    uint8_t IM2[1024] = {0};
    
    HAL_Init();
    SystemClock_Config();
    MX_GPIO_Init();

    // 1. Inicializar pantalla ST7920
    ST7920_Init();

    ST7920_GraphicMode(0);
    ST7920_Clear();

	// Mensaje Estático Inicial
	ST7920_SendString(0, 0, "TECLADO 4x4");

    // 128 x 64
    //   0  ....    127
    // 128  ....    255
    // 256  ....    383
    // 384  ....    511
    // 512  ....    639
    // 640  ....    767
    // 768  ....    895
    // 896  ....   1023
    
	while (1)
	{

        for(int i = 0;i < 127; i++)
        {
            IM2(COLUMNA1-i) = IM1(COLUMNA1-1+i);
            IM2(COLUMNA2-i) = IM1(COLUMNA2-1+i);
            IM2(COLUMNA3-i) = IM1(COLUMNA3-1+i);
            IM2(COLUMNA4-i) = IM1(COLUMNA4-1+i);
            IM2(COLUMNA5-i) = IM1(COLUMNA5-1+i);
            IM2(COLUMNA6-i) = IM1(COLUMNA6-1+i);
            IM2(COLUMNA7-i) = IM1(COLUMNA7-1+i);
            IM2(COLUMNA8-i) = IM1(COLUMNA8-1+i);
        }


		tecla = teclado();
		// Formatear y actualizar únicamente la Fila 3
		snprintf(buffer_count, sizeof(buffer_count), "Tecla: %02u", tecla);
		ST7920_SendString(2, 0, buffer_count);

		HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0); // Toggle LED verde NUCLEO
     }

}

void MX_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    // Habilitar Relojes de GPIOB, GPIOC y GPIOD
    __HAL_RCC_GPIOB_CLK_ENABLE();
    __HAL_RCC_GPIOC_CLK_ENABLE();
    __HAL_RCC_GPIOD_CLK_ENABLE();
    __HAL_RCC_GPIOE_CLK_ENABLE();
    __HAL_RCC_GPIOF_CLK_ENABLE();

    // LED verde de estado (PB0)
    GPIO_InitStruct.Pin = GPIO_PIN_0;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

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
    
    // Columnas 1 a 4 de salida (C1 (PE2), C2 (PE4), C3 (PE5), C4 (PE6))
    GPIO_InitStruct.Pin = GPIO_PIN_2 | GPIO_PIN_4 | GPIO_PIN_5 | GPIO_PIN_6;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

    // Filas 1 de entrada (F1 (PE3))
    GPIO_InitStruct.Pin = GPIO_PIN_3;
    GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
    GPIO_InitStruct.Pull = GPIO_PULLDOWN;
    HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

    // Filas 2 a 4 de entrada (F2 (PF8), F3 (PF7), F4 (PF9))
    GPIO_InitStruct.Pin = GPIO_PIN_7 | GPIO_PIN_8 | GPIO_PIN_9;
    GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
    GPIO_InitStruct.Pull = GPIO_PULLDOWN;
    HAL_GPIO_Init(GPIOF, &GPIO_InitStruct);

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
