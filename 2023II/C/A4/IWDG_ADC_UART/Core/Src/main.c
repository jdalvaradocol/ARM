/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2023 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "adc.h"
#include "dac.h"
#include "usart.h"
#include "usb_otg.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

extern ADC_HandleTypeDef hadc2;
extern UART_HandleTypeDef huart3;


/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)

int CyclesCounterInit( uint32_t clockSpeed );
#define CyclesCounterRead()		DWT->CYCCNT
#define CyclesCounterReset()    (DWT->CYCCNT = 0)

#define FRE_CLOCK	280000000
#define MUESTRAS	100
#define FS			FRE_CLOCK/MUESTRAS

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  uint16_t 	adc_value = 0;
  uint16_t adc[MUESTRAS] ;
  uint16_t sample = 0;

  uint8_t uni = 0;
  uint8_t dec = 0;
  uint8_t cen = 0;
  uint8_t um  = 0;
  uint8_t dm   = 0;

  uint8_t iu = 0;
  uint8_t id = 0;
  uint8_t ic = 0;
  uint8_t im  = 0;
  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_USB_OTG_HS_USB_Init();
  MX_ADC2_Init();
  MX_USART3_UART_Init();
  MX_DAC1_Init();
  /* USER CODE BEGIN 2 */

  CyclesCounterInit(FRE_CLOCK); // Enable the cycle counter

  printf("Inicio ADC DAC \r\n");

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */

	CyclesCounterReset();

	HAL_ADC_Start(&hadc2);
	HAL_ADC_PollForConversion(&hadc2, 1000);
	adc_value = HAL_ADC_GetValue(&hadc2);
	HAL_ADC_Stop(&hadc2);

	adc[sample] = adc_value;
	sample++;

	while(CyclesCounterRead() <  FS )
	{}

	if(sample > MUESTRAS)
	{
		for(int i=0 ;i < MUESTRAS;i++)
		{
			HAL_GPIO_TogglePin(LD1_GPIO_Port, LD1_Pin);
			// printf("ADC = %d size = %d  \r\n",adc_value,sample);

			// 00000 - 65536

			iu = (i % 10) + 48;
			id = ((i /    10) % 10) + 48;
			ic = ((i /   100) % 10) + 48;
			im = ((i /  1000) % 10) + 48;

			uni = (adc_value % 10) + 48;
			dec = ((adc_value /    10) % 10) + 48;
			cen = ((adc_value /   100) % 10) + 48;
			um  = ((adc_value /  1000) % 10) + 48;
			dm  = ((adc_value / 10000) % 10) + 48;

			HAL_UART_Transmit(&huart3, (uint8_t *) "(" , 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,              &im, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,              &ic, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,              &id, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,              &iu, 1, 0xFFFF);

			HAL_UART_Transmit(&huart3,              &dm, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,              &um, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,             &cen, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,             &dec, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3,             &uni, 1, 0xFFFF);
			HAL_UART_Transmit(&huart3, (uint8_t *)  ")", 1, 0xFFFF);

			sample = 0;
		}

	}
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /*AXI clock gating */
  RCC->CKGAENR = 0xFFFFFFFF;

  /** Supply configuration update enable
  */
  HAL_PWREx_ConfigSupply(PWR_DIRECT_SMPS_SUPPLY);

  /** Configure the main internal regulator output voltage
  */
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE0);

  while(!__HAL_PWR_GET_FLAG(PWR_FLAG_VOSRDY)) {}

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI48|RCC_OSCILLATORTYPE_LSI
                              |RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
  RCC_OscInitStruct.LSIState = RCC_LSI_ON;
  RCC_OscInitStruct.HSI48State = RCC_HSI48_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 1;
  RCC_OscInitStruct.PLL.PLLN = 70;
  RCC_OscInitStruct.PLL.PLLP = 2;
  RCC_OscInitStruct.PLL.PLLQ = 20;
  RCC_OscInitStruct.PLL.PLLR = 2;
  RCC_OscInitStruct.PLL.PLLRGE = RCC_PLL1VCIRANGE_3;
  RCC_OscInitStruct.PLL.PLLVCOSEL = RCC_PLL1VCOWIDE;
  RCC_OscInitStruct.PLL.PLLFRACN = 0;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2
                              |RCC_CLOCKTYPE_D3PCLK1|RCC_CLOCKTYPE_D1PCLK1;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.SYSCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB3CLKDivider = RCC_APB3_DIV2;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_APB1_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_APB2_DIV2;
  RCC_ClkInitStruct.APB4CLKDivider = RCC_APB4_DIV2;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_7) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */

PUTCHAR_PROTOTYPE
{
  /* Place your implementation of fputc here */
  /* e.g. write a character to the USART3 and Loop until the end of transmission */
  HAL_UART_Transmit(&huart3, (uint8_t *)&ch, 1, 0xFFFF);

  return ch;
}

int CyclesCounterInit( uint32_t clockSpeed )
{
   DWT->CTRL  |= 1; // *DWT_CTRL  |= 1;
   return 1;
}

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
