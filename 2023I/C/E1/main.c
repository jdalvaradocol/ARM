
// Conversor de Analogo a Digital

#include "Nokia5110.h"
#include "PLL.h"
#include "tm4c123gh6pm.h"

#include <stdio.h>
#include <stdlib.h>

unsigned long ADC0_InSeq(void);  
void init_ADC(void);
void PortB_Init(void);
void PortF_Init(void);

//  function delays 3*ulCount cycles
void Delay(unsigned long ulCount){
  do{
    ulCount--;
	}while(ulCount);
}


int main(void){

	float v = 0;
  unsigned short ADCvalue;

	ADCvalue = 0;
	
  char buffer[20];

	init_ADC();
	PortB_Init();

  PLL_Init();                           // set system clock to 50 MHz
  Nokia5110_Init();

  Nokia5110_Clear();
  Nokia5110_OutString("* CONVERSOR**  ANALOGO **  DIGITAL:*");
  
	while(1)	
	{
    Nokia5110_SetCursor(0,4);          // five leading spaces, bottom row
		Nokia5110_OutString("ADC =");	
    
		Nokia5110_OutUDec(ADCvalue);

		sprintf(buffer,"Vol = %1.2f",v);    // Guardamos el mensaje a desplegar

    Nokia5110_SetCursor(0,5);          // five leading spaces, bottom row		
		Nokia5110_OutString(buffer);
			
    Delay(833333);                     // delay ~0.5 sec at 50 MHz
				
    ADCvalue = ADC0_InSeq();
		v = (ADCvalue/4096.0) * (3.3);		
		
    GPIO_PORTB_DATA_R ^= 0x04;		
				
	}
}
unsigned long ADC0_InSeq(void){  
	
	unsigned long result;
  
	ADC0_PSSI_R = 0x0008;            	// 1) initiate SS3
  
	while((ADC0_RIS_R&0x08)==0){}   	// 2) wait for conversion done
  result = ADC0_SSFIFO3_R&0xFFF;   	// 3) read result
  ADC0_ISC_R = 0x0008;             	// 4) acknowledge completion
	return result;
}

void PortB_Init(void)
{ 
	int delay;
  SYSCTL_RCGC2_R |= 0x00000002;     // 1) F clock
	delay = (int) SYSCTL_RCGC2_R;         //    
  delay++;
	
	GPIO_PORTB_CR_R = 0xFF;           // allow changes to PB7-0       
  GPIO_PORTB_AMSEL_R = 0x00;        // 3) disable analog function
  GPIO_PORTB_PCTL_R = 0x00000000;   // 4) GPIO clear bit PCTL  
  GPIO_PORTB_DIR_R = 0xFF;          // 5) PB7 - 0 output   
  GPIO_PORTB_AFSEL_R = 0x00;        // 6) no alternate function
  GPIO_PORTB_PUR_R = 0x00;          // disable pullup resistors PB7 - 0       
  GPIO_PORTB_DEN_R = 0xFF;          // 7) enable digital pins PB7 - 0        
}
void init_ADC(void)
{
	int delay;
  
	SYSCTL_RCGC2_R |= 0x00000010;   							// 1) Configura PE3 analogo
  delay = (int) SYSCTL_RCGC2_R;         				//    
  delay++;
	
	GPIO_PORTE_DIR_R   &= (unsigned long) ~0x08;     
  GPIO_PORTE_AFSEL_R |= (unsigned long)  0x08;     
  GPIO_PORTE_DEN_R   &= (unsigned long) ~0x08;     
  GPIO_PORTE_AMSEL_R |= (unsigned long)  0x08;     
  
	SYSCTL_RCGC0_R |= 0x00010000;   									// 2) Activa ADC0 
  delay = (int) SYSCTL_RCGC0_R;         
  delay++;
		
	SYSCTL_RCGC0_R &= (unsigned long) ~0x00000000;  	// 3) Muestras 125K 
	for(int i = 0;i < 10;i++){}
			
	ADC0_SSPRI_R  = 0x0123;          									// 4) Secuencia 3 de mayor prioridad 
  ADC0_EMUX_R   = 0x0000;         									// 5) seq3 is software trigger
  
	ADC0_SSMUX3_R = (ADC0_SSMUX3_R&0xFFFFFFF0)+0; 		// 6) channel AIN0 (PE3)
  ADC0_SSCTL3_R = 0x0006;         									// 7) no TS0 D0, yes IE0 END0
  ADC0_ACTSS_R |= 0x0008;         									// 8) Promedio on/off Secuencia 3
  
}
