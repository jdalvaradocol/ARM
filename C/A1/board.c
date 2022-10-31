
#include "tm4c123gh6pm.h"
#include "board.h"

/* Prototipo de la funcion */
void init_PORTF(void);

void board_init(void)
{
	init_PORTF();
}

void init_PORTF(void)
{	
	int nop=0;
	
	// Configuracion del puerto F
	// SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x20	
	
	SYSCTL_RCGC2_R |= 0x20;
	nop = 0;
	nop = 1;
	
	// GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY	
	GPIO_PORTF_LOCK_R = 0x4c4f434b;
	
	// Habilita la escritura en los registros del PORTF
	GPIO_PORTF_CR_R = 0xFF;
	
	// No activa el modo analogo en PORTF
	GPIO_PORTF_AMSEL_R = 0x00;
	
	// No activa los perifericos en PORTF	
	GPIO_PORTF_PCTL_R = 0x00000000;
			
	// Configura entrada y salidas I/O en PORTF
	//  F4 -  F3 -  F2 -  F1 -  F0
	// SW4 - LED0 - LED1 - LED2 - SW0	
	// 	 0 -    1 -    1 -   1 -   0 = 0x0E 
			
	// 0 = ENTRADA
	// 1 = SALIDA
	
	GPIO_PORTF_DIR_R = 0x0E;
			 
	// No configura perifericos en el PORTF
	GPIO_PORTF_AFSEL_R = 0x00;

	// Configura pull-up para PF0 y PF4
  GPIO_PORTF_PUR_R = 0x11;

	// Habilita modo digital para PF0 a PF4
	GPIO_PORTF_DEN_R = 0x1F;

}

void delay_ms(int delay)
{
	int i=0,j=0;
	
	for(i=0;i<delay;i++)
	{
		for(j=0;j<5333;j++)
		{}
	}
}
