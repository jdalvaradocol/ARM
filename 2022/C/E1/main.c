
// Conversor de Analogo a Digital

#include "board.h"
#include "adc.h"
#include "PLL.h"
#include "Nokia5110.h"
#include "tm4c123gh6pm.h"

#include <stdio.h>
#include <stdlib.h>

// Fosc = 16MHz T = (1/Fosc) * 4 = 250ns 
// 1ms / 250ns = 4000

static void delay_ms(int delay)
{
		for(int i = 0;i < delay;i++)
		{
			for(int j = 0;j < 4000;j++)
			{}
		}
}

int main(void){

	double v = 0;
	unsigned short ADCvalue = 0;
	
  char buffer[20];

	board_init();
	init_ADC();
			
	PLL_Init();                           // set system clock to 50 MHz
  Nokia5110_Init();

  Nokia5110_Clear();
  Nokia5110_OutString("* CONVERSOR**  ANALOGO **  DIGITAL:*");
  
	while(1)	
	{
    Nokia5110_SetCursor(0,4);          
		Nokia5110_OutString("ADC =");	
    
		Nokia5110_OutUDec(ADCvalue);
		sprintf(buffer,"Vol = %1.2f", v);    								// Guardamos el mensaje a desplegar

    Nokia5110_SetCursor(0,5);          
		Nokia5110_OutString(buffer);
			
		delay_ms(25);                    
		
		v = ((ADCvalue/4096.0) * 3.3);
			
    ADCvalue = ADC0_InSeq();
    GPIO_PORTB_DATA_R ^= 0x01;		
				
	}
}
