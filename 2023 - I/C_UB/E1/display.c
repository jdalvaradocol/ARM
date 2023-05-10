
// Declaracion de librerias.

#include <stdio.h>
#include <stdint.h>
#include "config.h"
#include "display.h"
#include "tm4c123gh6pm.h"

unsigned long display(int numero)	
{
	unsigned long salida;
	
	if(numero == 0)
	{
		salida = 0x40;
	}
	else if(numero == 1)
	{
		salida = 0x79;
	}
	else if(numero == 1)
	{
		salida = 0x79;
	}
	else if(numero == 2)
	{
		salida = 0x24;
	}
	else if(numero == 3)
	{
		salida = 0x30;
	}
	else if(numero == 4)
	{
		salida = 0x19;
	}
	else if(numero == 5)
	{
		salida = 0x12;
	}
	else if(numero == 6)
	{
		salida = 0x02;
	}
	else if(numero == 7)
	{
		salida = 0x78;
	}
	else if(numero == 8)
	{
		salida = 0x00;
	}
	else if(numero == 9)
	{
		salida = 0x10;
	}
	else
	{
		salida = 0xFF;
	}
	
	return salida;
	
}

void visualizar(int numero, int delay)
{
	int unidad;
	int decena;
	
	decena = numero / 10;
	unidad = numero % 10;
	
	for(int i = 0;i < delay; i++)
	{
		DISPLAY  = display(unidad);
		DIG1DIG2 = 0x00;
		DIG3DIG4 = 0x10;			
		delay_ms(1);
		
		DISPLAY  = display(decena);
		DIG1DIG2 = 0x00;
		DIG3DIG4 = 0x20;			
		delay_ms(1);
	}
		
}

int contador_estado(int contador, unsigned long entrada)	
{
	
	int salida = 0;
	
	if(entrada == 0x01)
		{
			salida = contador + 1;
			
			if(salida == 12)
			{
				salida = 0;
			}
				
		}
		else if(entrada == 0x02)
		{
			salida = contador - 1;

			if(salida == -1)
			{
				salida = 11;
			}

		}
		else if(entrada == 0x04)
		{
			salida = contador;
		}
		else if(entrada == 0x08)
		{
			salida = 0;
		}
		
		return salida;
		
}
