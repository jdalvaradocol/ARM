
#include "tm4c123gh6pm.h"
#include "board.h"

/* Prototipo de la funcion */
void init_PORTB(void);
void init_PORTD(void);
void init_PORTE(void);
void init_PORTF(void);

void board_init(void)
{
	init_PORTB();
	init_PORTD();
	init_PORTE();
	init_PORTF();
}

void init_PORTB(void)
{	
	int nop=0;
	
	// Configuracion del puerto B
	// SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x02	
	
	SYSCTL_RCGC2_R |= 0x02;
	nop = 0;
	nop = 1;

	// Habilita la escritura en los registros del PORTB
	GPIO_PORTB_CR_R = 0xFF;
	
	// No activa el modo analogo en PORTB
	GPIO_PORTB_AMSEL_R = 0x00;
	
	// No activa los perifericos en PORTB	
	GPIO_PORTB_PCTL_R = 0x00000000;
			
	// Configura entrada y salidas I/O en PORTB
	//  B7 - B6 - B5 - B4 - B3 - B2 - B1 - B0
	// 	DP - SG - SF - SE - SD - SC	-	SB - SA
	// 	 1 -  1 -  1 -  1 -  1 -  1 -  1 -  1 = 0xFF 
			
	// 0 = ENTRADA
	// 1 = SALIDA
	
	GPIO_PORTB_DIR_R = 0xFF;
			 
	// No configura perifericos en el PORTB
	GPIO_PORTB_AFSEL_R = 0x00;

	// Configura pull-up apagadas
	GPIO_PORTB_PUR_R = 0x00;

	// Habilita modo digital para PB0 a PB7
	GPIO_PORTB_DEN_R = 0xFF;

}

void init_PORTD(void)
{	
	int nop=0;
	
	// Configuracion del puerto E
	// SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x10	
	
	SYSCTL_RCGC2_R |= 0x10;
	nop = 0;
	nop = 1;

	// Habilita la escritura en los registros del PORTE
	GPIO_PORTE_CR_R = 0xFF;
	
	// No activa el modo analogo en PORTE
	GPIO_PORTE_AMSEL_R = 0x00;
	
	// No activa los perifericos en PORTE	
	GPIO_PORTE_PCTL_R = 0x00000000;
			
	// Configura entrada y salidas I/O en PORTE
	//  E7 - E6 - E5 - E4 - E3 - E2 - E1 - E0
	// 	          D4 - D3 
	// 	 0 -  0 -  1 -  1 -  0 -  0 -  0 -  0 = 0x30 
			
	// 0 = ENTRADA
	// 1 = SALIDA
	
	GPIO_PORTE_DIR_R = 0x30;
			 
	// No configura perifericos en el PORTE
	GPIO_PORTE_AFSEL_R = 0x00;

	// Configura pull-up apagadas
	GPIO_PORTE_PUR_R = 0x00;

	// Habilita modo digital para PD6 a PD7
	GPIO_PORTE_DEN_R = 0x30;

}

void init_PORTE(void)
{	
	int nop=0;
	
	// Configuracion del puerto D
	// SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x08	
	
	SYSCTL_RCGC2_R |= 0x08;
	nop = 0;
	nop = 1;

	// GPIO_PORTD_LOCK_R = GPIO_LOCK_KEY	
	GPIO_PORTD_LOCK_R = 0x4c4f434b;

	// Habilita la escritura en los registros del PORTD
	GPIO_PORTD_CR_R = 0xFF;
	
	// No activa el modo analogo en PORTD
	GPIO_PORTD_AMSEL_R = 0x00;
	
	// No activa los perifericos en PORTD	
	GPIO_PORTD_PCTL_R = 0x00000000;
			
	// Configura entrada y salidas I/O en PORTB
	//  D7 - D6 - D5 - D4 - D3 - D2 - D1 - D0
	// 	D1 - D2 
	// 	 1 -  1 -  0 -  0 -  0 -  0 -  0 -  0 = 0xC0 
			
	// 0 = ENTRADA
	// 1 = SALIDA
	
	GPIO_PORTD_DIR_R = 0xC0;
			 
	// No configura perifericos en el PORTD
	GPIO_PORTD_AFSEL_R = 0x00;

	// Configura pull-up apagadas
	GPIO_PORTD_PUR_R = 0x00;

	// Habilita modo digital para PD6 a PD7
	GPIO_PORTD_DEN_R = 0xC0;

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
	// SW4 - SW3 - SW2 - SW1 - SW0	
	// 	 0 -   0 -   0 -   0 -   0 = 0x00 
			
	// 0 = ENTRADA
	// 1 = SALIDA
	
	GPIO_PORTF_DIR_R = 0x00;
			 
	// No configura perifericos en el PORTF
	GPIO_PORTF_AFSEL_R = 0x00;

	// Configura pull-up apagadas
	GPIO_PORTF_PUR_R = 0x00;

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

int Lectura(void)
{
	return GPIO_PORTF_DATA_R;
}

