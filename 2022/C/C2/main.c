

#include <stdlib.h>
#include <stdio.h>

#include "tm4c123gh6pm.h"
#include "board.h"
#include "display.h"
#include "Nokia5110.h"
#include "imagen.h"

/* Prototipo de la funcion */

int main()
{
	
	int contador = 0;
	float contador_float= 0.0;
	char buffer[12];
	
	board_init();
	Nokia5110_Init();
	Nokia5110_Clear();
		
	while(1)
	{
		Nokia5110_DrawFullImage(b1);
		delay_ms(150);
		Nokia5110_DrawFullImage(b2);
		delay_ms(150);	
		Nokia5110_DrawFullImage(b3);
		delay_ms(150);	
		Nokia5110_DrawFullImage(b4);
		delay_ms(150);	
		Nokia5110_DrawFullImage(b5);
		delay_ms(150);	
		Nokia5110_DrawFullImage(b6);
		delay_ms(150);	
		Nokia5110_DrawFullImage(b7);
		delay_ms(150);	
		Nokia5110_DrawFullImage(b8);
		delay_ms(150);	
	}
	
}

