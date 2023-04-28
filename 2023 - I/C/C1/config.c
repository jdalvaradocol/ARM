
// Declaracion de librerias.


#include <stdio.h>
#include <stdint.h>
#include "config.h"
#include "tm4c123gh6pm.h"

unsigned long dato_entrada(unsigned long dato)
{
		unsigned long salida;
		
		if(SW != 0x00)
		{
			salida = SW;
		}
		else
		{
			salida = dato;
		}
		
		return salida;

}

void delay_ms(int delay)
{
	for(int i=0;i < delay; i++)
	{
		for(int j=0;j < 5333; j++)
		{}
	}
}
