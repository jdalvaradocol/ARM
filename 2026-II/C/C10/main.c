#include "stm32f7xx_hal.h"

void SystemClock_Config(void);
void MX_GPIO_Init(void);

/* Interrupción del SysTick para incrementar el contador global (uwTick) */
void SysTick_Handler(void)
{
  HAL_IncTick(); // Incrementa el tick global en 1 ms
}

int main(void)
{
  HAL_Init();
  SystemClock_Config();
  MX_GPIO_Init();

  /* Variable de control para el temporizador no bloqueante */
  //  uint32_t tiempo_actual;
  uint32_t tiempo_previo_LED1 = HAL_GetTick();
  uint32_t tiempo_previo_LED2 = HAL_GetTick();
  uint32_t tiempo_previo_LED3 = HAL_GetTick();
  const uint32_t intervalo_LED1 = 230; // Alternar LED cada 230 ms
  const uint32_t intervalo_LED2 = 370; // Alternar LED cada 370 ms
  const uint32_t intervalo_LED3 = 430; // Alternar LED cada 430 ms

  while (1)
  {

    if (HAL_GetTick() - tiempo_previo_LED1 >= intervalo_LED1)
    {
        tiempo_previo_LED1 = HAL_GetTick();
        HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0);
    }

    if (HAL_GetTick() - tiempo_previo_LED2 >= intervalo_LED2)
    {
        tiempo_previo_LED2 = HAL_GetTick();
        HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_7);
    }

    if (HAL_GetTick() - tiempo_previo_LED3 >= intervalo_LED3)
    {
        tiempo_previo_LED3 = HAL_GetTick();
        HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_14);
    }

  }
}

void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  __HAL_RCC_GPIOB_CLK_ENABLE();
  __HAL_RCC_GPIOC_CLK_ENABLE();

  /* Salida: LED 1 (PB0) y LED 2 (PB7) y LED 3 (PB14) */
  GPIO_InitStruct.Pin = GPIO_PIN_0 | GPIO_PIN_7 | GPIO_PIN_14;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /* Entrada: Botón de usuario (PC13) */
  GPIO_InitStruct.Pin = GPIO_PIN_13;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);
}

void SystemClock_Config(void)
{
  // Configuración estándar del reloj
}
