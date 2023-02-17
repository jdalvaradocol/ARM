
#include "tm4c123gh6pm.h"
#include "board.h"
#include "display.h"

/* Prototipo de la funcion */

int main()
{
	
	int dato = 0;
	int entrada = 0;
	
	board_init();
	
	while(1)
	{
		
		if (Lectura() != 0)
		{
			entrada = Lectura();
		}
			
		if (entrada == 1)
		{
			dato++;
			
			if(dato > 9999)
			{
				dato = 0;
			}
			
		}	
		else if (entrada == 2)
		{
			dato--;
			
			if(dato < 0)
			{
				dato = 9999;
			}
			
		}
		else if (entrada == 4)
		{
			dato += 2;
			
			if(dato > 9999)
			{
				dato = 0;
			}
			
		}	
		else if (entrada == 8)
		{
			dato -= 2;
			
			if(dato < 0)
			{
				dato = 9999;
			}
						
		}
		
		visualizacion(dato,50);
	}
	
	
}

