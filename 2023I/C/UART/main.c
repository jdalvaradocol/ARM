#include <stdint.h>
#include <math.h>
#include "PLL.h"
#include "UART.h"
#include "tm4c123gh6pm.h"
#include "Nokia5110.h"

#include <stdio.h>
#include <stdlib.h>

void PortB_Init(void);
void delay_ms(int a);

int main(void)
{
  
	PortB_Init();
	Nokia5110_Init();
  PLL_Init();       							// 50  MHz
  UART_Init();              			// initialize UART
	
	int x;
	int ch;
	char buffer[20];
	
	Nokia5110_Clear();
  Nokia5110_OutString("*** UART ***");
	
	while(1)
	{
	
		// ENVIA		
			
		ch++;

		if(ch >= 255)
		{
			ch = 0;
		}
			
		UART_OutChar(ch);
		
		// LEER
		
		x = UART_InChar();
	
		if(x < 0)
		{
			x = 256 + x;		
		}
		
		sprintf(buffer,"IN = %3d ",x);		
		Nokia5110_SetCursor(0,2); 
		Nokia5110_OutString(buffer);
		sprintf(buffer,"                ");		
		
		sprintf(buffer,"OUT = %3d ",ch);		
		Nokia5110_SetCursor(0,4); 
		Nokia5110_OutString(buffer);
		sprintf(buffer,"                ");		
		
		GPIO_PORTB_DATA_R ^= 0x01; 
		delay_ms(500);
		
	}
}		

void PortB_Init(void)
{ 
	volatile unsigned long delay;
  SYSCTL_RCGC2_R |= 0x00000002;     // 1) F clock
  delay = SYSCTL_RCGC2_R;           // delay   
  GPIO_PORTB_CR_R = 0xFF;           // allow changes to PB7-0       
  GPIO_PORTB_AMSEL_R = 0x00;        // 3) disable analog function
  GPIO_PORTB_PCTL_R = 0x00000000;   // 4) GPIO clear bit PCTL  
  GPIO_PORTB_DIR_R = 0xFF;          // 5) PB7 - 0 output   
  GPIO_PORTB_AFSEL_R = 0x00;        // 6) no alternate function
  GPIO_PORTB_PUR_R = 0x00;          // disable pullup resistors PB7 - 0       
  GPIO_PORTB_DEN_R = 0xFF;          // 7) enable digital pins PB7 - 0        
}

void delay_ms(int a)
{
	for(int i=0 ; i < a ; i++)
	{
		for(int j=0 ; j < 3250 ; j++)
		{
		}
	}
}

