
#include <stdlib.h>
#include <stdio.h>

#include "tm4c123gh6pm.h"
#include "gpio.h"
#include "config.h"
#include "display.h"
#include "Nokia5110.h"

#define COLUMNAS	84
#define FILAS			6
#define MAX_SIZE	COLUMNAS*FILAS

/* Prototipo de la funcion */

int main()
{
		
	char imagen[MAX_SIZE];
	
	GPIOF_init();
	Nokia5110_Init();
	Nokia5110_Clear();
	
	for(int i=0 ; i < MAX_SIZE; i++)
	{
		imagen[i] = 0;
	}	
	
	imagen[208] = 0xC0;
	imagen[209] = 0xE0;
	imagen[210] = 0xE0;
	imagen[211] = 0xE0;
	imagen[212] = 0xC0;

	imagen[292] = 0x01;
	imagen[293] = 0x03;
	imagen[294] = 0x03;
	imagen[295] = 0x03;
	imagen[296] = 0x01;
		
	Nokia5110_DrawFullImage(imagen);
	delay_ms(500);

	unsigned long 	entrada = 0;
	char 	pix 		= 0;
	char 	pixa 		= 0;
	int 	i = 0,j = 0;

	while(1)
	{	

		entrada = dato_entrada();
		
		if (entrada == P1_ON)
		{		
			for(j = 0 ; j < FILAS ; j++)
			{
				for( i = COLUMNAS ; i > 0 ; i--)
				{
					imagen[(i+1)+(j*COLUMNAS)] = imagen[(i)+(j*COLUMNAS)]; 			
				}
				imagen[(j*COLUMNAS)] = imagen[((j+1)*COLUMNAS)-1];
			}
		}		
		else if (entrada == P2_ON)
		{			
			for( j = 0 ; j < FILAS ; j++)
			{
				for( i = 0 ; i < COLUMNAS ; i++)
				{
					imagen[(i)+(j*COLUMNAS)] = imagen[(i+1)+(j*COLUMNAS)]; 			
				}
				imagen[((j+1)*COLUMNAS)-1] = imagen[j*COLUMNAS];				
			}
		}
		else if (entrada == P3_ON)
		{		
			for( i=0 ; i < COLUMNAS ;i++)
			{					
				for( j=0 ; j < FILAS; j++)
				{
					pixa = ((imagen[i+(COLUMNAS*j)])&0x80) >> 7;
					imagen[i+(COLUMNAS*(j))]= ((imagen[i+(COLUMNAS*(j))]&0x7F) << 1) + pix;
					pix = pixa;
				}		
			}
		}
		else if (entrada == P4_ON)
		{		
			for( i=0 ; i < COLUMNAS ;i++)
			{	
				for( j = FILAS-1 ; j >= 0; j--)
				{
					pixa = ((imagen[i+(COLUMNAS*j)])&0x01) << 7;
					imagen[i+(COLUMNAS*(j))]= ((imagen[i+(COLUMNAS*(j))]&0xFE) >> 1) + pix;
					pix = pixa;
				}		
			}
		}
		
		Nokia5110_DrawFullImage(imagen);
		delay_ms(150);
		
	}
}