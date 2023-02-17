
#include "tm4c123gh6pm.h"
#include "board.h"


uint8_t gpioRead(uint8_t bit)
{
	
	if((GPIO_PORTF_DATA_R&bit) == bit)
	{
		return (1);
	}
	else
	{
		return (0);
	}
		
	// Leer los GPIO digital        

}

void gpioWrite(uint8_t bit, uint8_t dato)
{	

	if(dato == ON)
	{
		GPIO_PORTB_DATA_R |= (unsigned long)(bit);   		// Escribe los GPIO digital
	}
	else if(dato == OFF)
	{
		GPIO_PORTB_DATA_R &= (unsigned long)(bit^0xFF);   		// Escribe los GPIO digital
	}
	
}


static void PortF_init(void)
{ 
  SYSCTL_RCGC2_R       |= 0x00000020;     		// 1) F clock
  for (int i = 0; i < 100; i++){}   /* wait a while */
	
	GPIO_PORTF_LOCK_R 		= 0x4C4F434B;   			// 2) unlock PortF PF0  
  GPIO_PORTF_CR_R				= 0x1F;           		// allow changes to PF4-0       
  GPIO_PORTF_AMSEL_R 		= 0x00;        				// 3) disable analog function
  GPIO_PORTF_PCTL_R 		= 0x00000000;   			// 4) GPIO clear bit PCTL  
  GPIO_PORTF_DIR_R 			= 0x00;          			// 5) PF4,PF0 input, PF3,PF2,PF1 output   
  GPIO_PORTF_AFSEL_R 		= 0x00;        				// 6) no alternate function
  GPIO_PORTF_PUR_R 			= 0x00;          			// enable pullup resistors on PF4,PF0       
  GPIO_PORTF_DEN_R 			= 0x0F;          			// 7) enable digital pins PF4-PF0
}

static void PortB_init(void)
{ 

  SYSCTL_RCGC2_R       |= 0x00000002;     		// 1) F clock
  for (int i = 0; i < 100; i++){}   					/* wait a while */
  GPIO_PORTB_CR_R				= 0xFF;           		// allow changes to PF4-0       
  GPIO_PORTB_AMSEL_R 		= 0x00;        				// 3) disable analog function
  GPIO_PORTB_PCTL_R 		= 0x00000000;   			// 4) GPIO clear bit PCTL  
  GPIO_PORTB_DIR_R 			= 0xFF;          			// 5) PF4,PF0 input, PF3,PF2,PF1 output   
  GPIO_PORTB_AFSEL_R 		= 0x00;        				// 6) no alternate function
  GPIO_PORTB_PUR_R 			= 0x00;          			// enable pullup resistors on PF4,PF0       
  GPIO_PORTB_DEN_R 			= 0xFF;          			// 7) enable digital pins PF4-PF0
}


static void PortE_init(void)
{ 

  SYSCTL_RCGC2_R       |= 0x00000010;     		// 1) E clock
  for (int i = 0; i < 100; i++){}   /* wait a while */

  GPIO_PORTE_CR_R				= 0xFF;           		//        
  GPIO_PORTE_AMSEL_R 		= 0x08;        				// 3)
  GPIO_PORTE_PCTL_R 		= 0x00000000;   			// 4)   
  GPIO_PORTE_DIR_R 			= 0xF7;          			// 5)    
  GPIO_PORTE_AFSEL_R 		= 0x08;        				// 6) 
  GPIO_PORTE_PUR_R 			= 0x00;          			//            
  GPIO_PORTE_DEN_R 			= 0xF7;          			// 7) 

}

void board_init(void)
{
	PortB_init();
	PortE_init();
	PortF_init();
}
