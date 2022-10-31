

#include "board.h"
#include "display.h"
#include "tm4c123gh6pm.h"

int display(int num_decimal)
{
	int salida = 0;
		
	if(num_decimal == 0)
	{
		salida = 0x40;
	}
	else if(num_decimal == 1)
	{
		salida = 0x79;
	}
	else if(num_decimal == 2)
	{
		salida = 0x24;
	}
	else if(num_decimal == 3)
	{
		salida = 0x30;
	}
	else if(num_decimal == 4)
	{
		salida = 0x19;
	}
	else if(num_decimal == 5)
	{
		salida = 0x12;
	}
	else if(num_decimal == 6)
	{
		salida = 0x02;
	}
	else if(num_decimal == 7)
	{
		salida = 0x78;
	}
	else if(num_decimal == 8)
	{
		salida = 0x00;
	}
	else if(num_decimal == 9)
	{
		salida = 0x10;
	}
	else 
	{
		salida = 0xFF;
	}
	
	return salida;
}



void visualizacion(int contador, int delay)
{
		int umil 		= 0; 
		int	centena = 0;
		int decena 	= 0;  
		int unidad 	= 0;  

		unidad 		= contador % 10;
		contador 	= contador /10;
	
		decena 		= contador % 10;
		contador 	= contador /10;
	
		centena 	= contador % 10;
		contador 	= contador /10;
	
		umil 			= contador % 10;
		contador 	= contador /10;
	
		/* D1 = PD7 D2 = PD6 D3 = PE4 D4 = PE5 */
	
		for(int i=0 ; i < delay; i++)
		{
			GPIO_PORTE_DATA_R = 0x10; // PE5 ON  PE4 OFF
			GPIO_PORTD_DATA_R = 0x00; // PD7 OFF PD6 OFF
			GPIO_PORTB_DATA_R = display(unidad);
			delay_ms(1);
			GPIO_PORTE_DATA_R = 0x20; // PE5 OFF PE4 ON
			GPIO_PORTB_DATA_R = display(decena);
			delay_ms(1);
			GPIO_PORTE_DATA_R = 0x00; // PE5 OFF PE4 OFF
			GPIO_PORTD_DATA_R = 0x40; // PD7 OFF PD6 ON
			GPIO_PORTB_DATA_R = display(centena);
			delay_ms(1);
			GPIO_PORTD_DATA_R = 0x80; // PD7 OFF PD6 OFF
			GPIO_PORTB_DATA_R = display(umil);
			delay_ms(1);
			GPIO_PORTE_DATA_R = 0x00; // PE5 OFF PE4 OFF
			GPIO_PORTD_DATA_R = 0x00; // PD7 OFF PD6 OFF
		}
}
