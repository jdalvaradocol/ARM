
// Incluir librerias

#include <stdio.h>
#include <stdint.h>
#include "tm4c123gh6pm.h"
#include "Nokia5110.h"
#include "PLL.h"
#include "config.h"

// Definiciones

// Prototipos de la funciones.

// Rutina main

int main()
{
	int contador = 0;
	float contadorf = 0.0;	
	char buffer[16];

  PLL_Init();          // set system clock to 50 MHz
	Nokia5110_Init();
		
	Nokia5110_Clear();
	Nokia5110_SetCursor(0,0);
	Nokia5110_OutString("*UPTC**2023*");
	
	while(1)
	{
		sprintf(buffer,"* S = %4d *",contador);		
		Nokia5110_SetCursor(0,2);
		Nokia5110_OutString(buffer);	
		contador++;
		
		sprintf(buffer,"* S = %2.1f *",contadorf);		
		Nokia5110_SetCursor(0,3);
		Nokia5110_OutString(buffer);	
		contadorf+=0.1;
		
		sprintf(buffer,"E=%d F=%.1f",contador,contadorf);		
		Nokia5110_SetCursor(0,5);
		Nokia5110_OutString(buffer);	
		delay_ms(200);
	}

}
