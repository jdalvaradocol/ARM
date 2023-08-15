

// Declaracion de librerias.

#include <stdio.h>
#include <stdint.h>
#include "tm4c123gh6pm.h"

// Prototipo de las funciones

void delay_ms(int delay);	

int main(void)
{
		
	int delay;
	
	// Configuracion del puerto B como salida
	
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_R | 0x02;	// Habilita el reloj para el PORTB 
	delay = (int)SYSCTL_RCGC2_R;									// Delay de 3 ciclos.
	delay++;
	
// Habilita la escritura en los registros del PORTB
	GPIO_PORTB_CR_R = 0xFF;

// No activa el modo analogo en PORTB					
	GPIO_PORTB_AMSEL_R = 0x00;

//	No activa los perifericos en PORTB
	GPIO_PORTB_PCTL_R = 0x00000000;

// 					Configura entrada y salidas I/O en PORTB
// 		 			B7 - B6 - B5 - B4 - B3 - B2 - B1 - B0
//	 		    DP - SG - SF - SE - SD - SC - SB - SA  
//	  			 1 -  1 -  1 -  1 -  1 -  1 -  1 -  1 = 0xFF 
//					 0 = ENTRADA
//	 				 1 = SALIDA

	GPIO_PORTB_DIR_R = 0xFF;
	
// No configura perifericos en el PORTB
	GPIO_PORTB_AFSEL_R = 0x00;
				
// Desactiva pull-up para GPIOB
	GPIO_PORTB_PUR_R = 0x00;
				
// Habilita modo digital para PB0 a PB7
  GPIO_PORTB_DEN_R = 0xFF;

	// Configuracion del puerto D como salida
	
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_R | 0x08;	// Habilita el reloj para el PORTD 
	delay = (int)SYSCTL_RCGC2_R;									// Delay de 3 ciclos.
	delay++;
	
// Configuracion del GPIO_LOCK
	GPIO_PORTD_LOCK_R = GPIO_LOCK_KEY;

// Habilita la escritura en los registros del PORTD
	GPIO_PORTD_CR_R = 0xFF;

// No activa el modo analogo en PORTD				
	GPIO_PORTD_AMSEL_R = 0x00;

//	No activa los perifericos en PORTD
	GPIO_PORTD_PCTL_R = 0x00000000;

// 					Configura entrada y salidas I/O en PORTD
// 		 			D7 -   D6 - D5 - D4 - D3 - D2 - D1 - D0
//	 		  DIG1 - DIG2 - XX - XX - T3 - T2 - T1 - T0  
//	  			 1 -    1 -  1 -  1 -  1 -  1 -  1 -  1 = 0xFF 
//					 0 = ENTRADA
//	 				 1 = SALIDA

	GPIO_PORTD_DIR_R = 0xFF;
	
// No configura perifericos en el PORTD
	GPIO_PORTD_AFSEL_R = 0x00;
				
// Desactiva pull-up para GPIOD
	GPIO_PORTD_PUR_R = 0x00;
				
// Habilita modo digital para PD0 a PD7
  GPIO_PORTD_DEN_R = 0xFF;

// Configuracion del puerto E como salida
	
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_R | 0x10;	// Habilita el reloj para el PORTE 
	delay = (int)SYSCTL_RCGC2_R;									// Delay de 3 ciclos.
	delay++;
	
// Habilita la escritura en los registros del PORTE
	GPIO_PORTE_CR_R = 0xFF;

// No activa el modo analogo en PORTE					
	GPIO_PORTE_AMSEL_R = 0x00;

//	No activa los perifericos en PORTE
	GPIO_PORTE_PCTL_R = 0x00000000;

// 					Configura entrada y salidas I/O en PORTE
// 		 			E7 - E6 -   E5 -   E4 - E3 - E2 -   E1 -    E0
//	 		    XX - XX - DIG3 - DIG4 - XX - XX - LED9 - LED10  
//	  			 0 -  0 -    1 -    1 -  1 -  1 -    1 -     1 = 0x3F 
//					 0 = ENTRADA
//	 				 1 = SALIDA

	GPIO_PORTE_DIR_R = 0x3F;
	
// No configura perifericos en el PORTE
	GPIO_PORTE_AFSEL_R = 0x00;
				
// Desactiva pull-up para GPIOE
	GPIO_PORTE_PUR_R = 0x00;
				
// Habilita modo digital para PB0 a PB7
  GPIO_PORTE_DEN_R = 0x3F;

	// Configuracion del puerto F como entrada
	
	SYSCTL_RCGC2_R = SYSCTL_RCGC2_R | 0x20;	// Habilita el reloj para el PORTD 
	delay = (int)SYSCTL_RCGC2_R;									// Delay de 3 ciclos.
	delay++;
	
// Configuracion del GPIO_LOCK
	GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY;

// Habilita la escritura en los registros del PORTF
	GPIO_PORTF_CR_R = 0xFF;

// No activa el modo analogo en PORTF				
	GPIO_PORTF_AMSEL_R = 0x00;

//	No activa los perifericos en PORTF
	GPIO_PORTF_PCTL_R = 0x00000000;

// 					Configura entrada y salidas I/O en PORTF
// 		 			F7 - F6 - F5 - F4 - F3 - F2 - F1 - F0
//	 		    XX - XX - XX - XX - P4 - P3 - P2 - P1  
//	  			 0 -  0 -  0 -  0 -  0 -  0 -  0 -  0 = 0x00 
//					 0 = ENTRADA
//	 				 1 = SALIDA

	GPIO_PORTF_DIR_R = 0x00;
	
// No configura perifericos en el PORTF
	GPIO_PORTF_AFSEL_R = 0x00;
				
// Desactiva pull-up para GPIOF
	GPIO_PORTF_PUR_R = 0x00;
				
// Habilita modo digital para PF0 a PF3
  GPIO_PORTF_DEN_R = 0x0F;

 // loop infinito 

	int contador = 0;
	unsigned long entrada = 0;

	while(1)
	{
		
		if(GPIO_PORTF_DATA_R != 0x00)
		{
			entrada = GPIO_PORTF_DATA_R;
		}
		
		if(entrada == 0x01)
		{
			contador++;
			
			if(contador == 12)
			{
				contador = 0;
			}
				
		}
		else if(entrada == 0x02)
		{
			contador--;

			if(contador == -1)
			{
				contador = 11;
			}

		}
		else if(entrada == 0x04)
		{
			// contador = contador;
		}
		else if(entrada == 0x08)
		{
			contador = 0;
		}
		
		if(contador == 0)
		{	
			GPIO_PORTB_DATA_R = 0xFE;
			GPIO_PORTD_DATA_R = 0x80;
			GPIO_PORTE_DATA_R = 0x00;			
		}
		else if(contador == 1)
		{	
			GPIO_PORTB_DATA_R = 0xFE;
			GPIO_PORTD_DATA_R = 0x40;
			GPIO_PORTE_DATA_R = 0x00;			
		}
		else if(contador == 2)
		{	
			GPIO_PORTB_DATA_R = 0xFE;
			GPIO_PORTD_DATA_R = 0x00;
			GPIO_PORTE_DATA_R = 0x20;			
		}
		else if(contador == 3)
		{	
			GPIO_PORTB_DATA_R = 0xFE;
			GPIO_PORTD_DATA_R = 0x00;
			GPIO_PORTE_DATA_R = 0x10;			
		}		
		else if(contador == 4)
		{	
			GPIO_PORTB_DATA_R = 0xFD;
			GPIO_PORTD_DATA_R = 0x00;
			GPIO_PORTE_DATA_R = 0x10;			
		}		
		else if(contador == 5)
		{	
			GPIO_PORTB_DATA_R = 0xFB;
			GPIO_PORTD_DATA_R = 0x00;
			GPIO_PORTE_DATA_R = 0x10;			
		}		
		else if(contador == 6)
		{	
			GPIO_PORTB_DATA_R = 0xF7;
			GPIO_PORTD_DATA_R = 0x00;
			GPIO_PORTE_DATA_R = 0x10;			
		}		
		else if(contador == 7)
		{	
			GPIO_PORTB_DATA_R = 0xF7;
			GPIO_PORTD_DATA_R = 0x00;
			GPIO_PORTE_DATA_R = 0x20;			
		}		
		else if(contador == 8)
		{	
			GPIO_PORTB_DATA_R = 0xF7;
			GPIO_PORTD_DATA_R = 0x40;
			GPIO_PORTE_DATA_R = 0x00;			
		}		
		else if(contador == 9)
		{	
			GPIO_PORTB_DATA_R = 0xF7;
			GPIO_PORTD_DATA_R = 0x80;
			GPIO_PORTE_DATA_R = 0x00;			
		}		
		else if(contador == 10)
		{	
			GPIO_PORTB_DATA_R = 0xEF;
			GPIO_PORTD_DATA_R = 0x80;
			GPIO_PORTE_DATA_R = 0x00;			
		}	
		
				else if(contador == 11)
		{	
			GPIO_PORTB_DATA_R = 0xDF;
			GPIO_PORTD_DATA_R = 0x80;
			GPIO_PORTE_DATA_R = 0x00;			
		}	
		delay_ms(200);
		
	}

}

void delay_ms(int delay)
{
	
	for(int i=0;i < delay; i++)
	{
	
		for(int j=0;j < 5333; j++)
		{
		}
	}


}


