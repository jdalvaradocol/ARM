

#include <stdlib.h>
#include <stdio.h>

#include "tm4c123gh6pm.h"
#include "board.h"
#include "display.h"
#include "Nokia5110.h"

/* Prototipo de la funcion */

int main()
{
	
	int contador = 0;
	float contador_float= 0.0;
	char buffer[12];
	
	board_init();
	Nokia5110_Init();
	Nokia5110_Clear();
		
	Nokia5110_OutString("LCDNokia5110");

	while(1)
	{
		Nokia5110_SetCursor(0,2);
		Nokia5110_OutString("Num = ");
		Nokia5110_SetCursor(6,2);
		Nokia5110_OutUDec(contador);

		Nokia5110_SetCursor(0,3);
		sprintf(buffer,"Num = %5d", contador);
		Nokia5110_OutString(buffer);

		Nokia5110_SetCursor(0,4);
		sprintf(buffer,"Num = %4.2f", contador_float);
		Nokia5110_OutString(buffer);

		Nokia5110_SetCursor(0,5);
		sprintf(buffer,"%3d %.2f ", contador,contador_float);
		Nokia5110_OutString(buffer);		
		
		contador++;
		contador_float += 0.1;
		delay_ms(500);
		
	}
	
}

