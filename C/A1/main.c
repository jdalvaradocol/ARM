
#include "tm4c123gh6pm.h"
#include "board.h"

/* Prototipo de la funcion */

int main()
{
	
	int dato;
	
	board_init();
	
	while(1)
	{
		
		dato = GPIO_PORTF_DATA_R&0x11;
		
		if(dato == 0x01)
		{
			GPIO_PORTF_DATA_R = MAGENTA;
			delay_ms(100);
			GPIO_PORTF_DATA_R = APAGADO;
			delay_ms(100);	
		}
		else if(dato == 0x10)
		{
			GPIO_PORTF_DATA_R = AMARRILLO;
			delay_ms(100);
			GPIO_PORTF_DATA_R = APAGADO;
			delay_ms(100);	
		}
		else if(dato == 0x00)
		{
			GPIO_PORTF_DATA_R = MORADO;
			delay_ms(100);
			GPIO_PORTF_DATA_R = APAGADO;
			delay_ms(100);	
		}
		
		
		}
	
	
}

