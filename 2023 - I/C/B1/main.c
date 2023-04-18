
// Incluir librerias

#include <stdio.h>
#include <stdint.h>
#include "tm4c123gh6pm.h"

// Definiciones

#define SW 			GPIO_PORTF_DATA_R
#define LEDSB 	GPIO_PORTB_DATA_R
#define LEDSE 	GPIO_PORTE_DATA_R

// Prototipos de la funciones.

void GPIOB_init(void); 
void GPIOE_init(void); 
void GPIOF_init(void);
void leds_out(int contador);
void sw_in(unsigned long *entrada);
void contador_estado(int *contador ,unsigned long entrada);

void delay_ms(int tiempo_ms); 

// Rutina main

int main()
{
	GPIOB_init();
	GPIOE_init();
	GPIOF_init();

	unsigned long entrada = 0;
	int contador = 0;

	while(1)
	{
		
		sw_in(&entrada);
		contador_estado(&contador, entrada);	
		leds_out(contador);
		delay_ms(200);	
	
	}

}
void delay_ms(int tiempo_ms)
{
	
	for(int i= 0; i < tiempo_ms; i++)
	{
		for(int j= 0; j < 5333; j++)
		{}
	}
	
}	

void GPIOB_init(void)
{	
	unsigned long NOP = 0;

// CONFIGURACION GPIOB
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_R | 0x02;
	
	// Equivalente a 3 ciclos de retardo
	
	NOP = SYSCTL_RCGC2_R;
	NOP++;
	
// Habilita la escritura en los registros del PORTF
			
	GPIO_PORTB_CR_R = 0xFF;

// No activa el modo analogo en PORTB
	GPIO_PORTB_AMSEL_R = 0x00;

// No activa los perifericos en PORTB
	GPIO_PORTB_PCTL_R = 0x00000000;
			
// Configura entrada y salidas I/O en PORTB
// B7 - B6 - B5 - B4 - B3 - B2 - B1 - B0
// DP - SG - SF - SE - SD - SC - SB - SA  
//  1 -  1 -  1 -  1 -  1 -  1 -  1 -  1 = 0xFF 
// 	0 = ENTRADA
// 	1 = SALIDA

	GPIO_PORTB_DIR_R = 0xFF;

// No configura perifericos en el PORTB
	GPIO_PORTB_AFSEL_R = 0x00;

// Desactiva pull-up para GPIOB
	GPIO_PORTB_PUR_R = 0x00;

// Habilita modo digital para PB0 a PB7		
	GPIO_PORTB_DEN_R = 0xFF;
	
}
void GPIOE_init(void) 
{
	unsigned long NOP = 0;

// CONFIGURACION GPIOE
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_R | 0x10;
	
// Equivalente a 3 ciclos de retardo
	
	NOP = SYSCTL_RCGC2_R;
	NOP++;
	
// Habilita la escritura en los registros del PORTE
	GPIO_PORTE_CR_R = 0x3F;

// No activa el modo analogo en PORTE
	GPIO_PORTE_AMSEL_R = 0x00;

// No activa los perifericos en PORTE
	GPIO_PORTE_PCTL_R = 0x00000000;
			
// Configura entrada y salidas I/O en PORTE
// E7 - E6 -   E5 -   E4 -   E3 -   E2 -    E1 -   E0
// XX - XX - DIG3 - DIG4 - AN.1 - AN.0 - LED10 - LED9  
//  0 -  0 -    1 -    1 -    0 -    0 -     1 -    1 = 0x33 
// 	0 = ENTRADA
// 	1 = SALIDA

	GPIO_PORTE_DIR_R = 0x33;

// No configura perifericos en el PORTE
	GPIO_PORTE_AFSEL_R = 0x00;

// Desactiva pull-up para GPIOE
	GPIO_PORTE_PUR_R = 0x00;

// Habilita modo digital para PE0 a PE5		
	GPIO_PORTE_DEN_R = 0x3F;

	
}
void GPIOF_init(void)
{
	unsigned long NOP = 0;

// CONFIGURACION GPIOF
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_R | 0x20;

// Equivalente a 3 ciclos de retardo
	
	NOP = SYSCTL_RCGC2_R;
	NOP++;

// Desbloquea el PORTF

		GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY; 
		
// Habilita la escritura en los registros del PORTF	
	GPIO_PORTF_CR_R = 0x0F;
 
// No activa el modo analogo en PORTF
	GPIO_PORTF_AMSEL_R = 0x00;

// No activa los perifericos en PORTF
	GPIO_PORTF_PCTL_R = 0x00000000;
			
// Configura entrada y salidas I/O en PORTF
//  F4 - F3 - F2 - F1 - F0
// SW1 - P4 - P3 - P2 - P1	
//   0 -  0 -  0 -  0 -  0 = 0x00 
// 0 = ENTRADA
// 1 = SALIDA

	GPIO_PORTF_DIR_R = 0x00;

// No configura perifericos en el PORTF
	GPIO_PORTF_AFSEL_R = 0x00;	

// Desactiva pull-up para GPIOF	
	GPIO_PORTF_PUR_R = 0x00;

// Habilita modo digital para PF0 a PF4
	GPIO_PORTF_DEN_R = 0x1F;
	
}	

void leds_out(int contador)
{

	if(contador == 0)
	{
		LEDSB = 0x03;
		LEDSE = 0x00;
	}
	else if(contador == 1)
	{
		LEDSB = 0x06;
		LEDSE = 0x00;
	}
	else if(contador == 2)
	{
		LEDSB = 0x0C;
		LEDSE = 0x00;
	}
	else if(contador == 3)
	{
		LEDSB = 0x18;
		LEDSE = 0x00;
	}
	else if(contador == 4)
	{
		LEDSB = 0x30;
		LEDSE = 0x00;
	}
	else if(contador == 5)
	{
		LEDSB = 0x60;
		LEDSE = 0x00;
	}
	else if(contador == 6)
	{
		LEDSB = 0xC0;
		LEDSE = 0x00;
	}
	else if(contador == 7)
	{
		LEDSB = 0x80; // Real Madrid 8 Millonarios 0 
		LEDSE = 0x01;
	}
	else if(contador == 8)
	{
		LEDSB = 0x00;
		LEDSE = 0x03;
	}
		
}

void sw_in(unsigned long *entrada)
{
	
	if(SW != 0)
	{
		*entrada = SW;		
	}

}

void contador_estado(int *contador,unsigned long entrada)
{
	if (entrada == 0x01)
	{
		*contador+=1;
			
		if(*contador == 9)
		{
			*contador = 0;
		}
			
	}
	else if (entrada == 0x02)
	{
		*contador-=1;
	
		if(*contador == -1)
		{
			*contador = 8;
		}
						
	}
	else if (entrada == 0x04)
	{
		// contador = contador + 0;
	}
	else if (entrada == 0x08)
	{
		*contador = 0;
	}
		
}
