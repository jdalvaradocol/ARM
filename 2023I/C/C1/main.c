
// Declaracion de librerias.

#include <stdio.h>
#include <stdint.h>
#include "display.h"
#include "gpio.h"
#include "config.h"
#include "tm4c123gh6pm.h"

// Declaracion de etiquetas
	
// Prototipo de las funciones
	
int main(void)
{
	GPIOB_init();
	GPIOD_init();
	GPIOE_init();	
	GPIOF_init();

 // loop infinito 

	int contador = 0;
	unsigned long entrada = 0;

	while(1)
	{
		entrada = dato_entrada(entrada);
		contador =  contador_estado(contador, entrada);	
		visualizar(contador,100);
	}

}
