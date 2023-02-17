
#include "adc.h"
#include "tm4c123gh6pm.h"

unsigned short ADC0_InSeq(void)
{  
	
	unsigned short result;
  
	ADC0_PSSI_R = 0x0008;            // 1) initiate SS3
  
	while((ADC0_RIS_R&0x08)==0)
	{}  														 // 2) wait for conversion done
  result = ADC0_SSFIFO3_R&0xFFF;   // 3) read result
  ADC0_ISC_R = 0x0008;             // 4) acknowledge completion
	return result;
}

void init_ADC(void)
{
      
	SYSCTL_RCGC0_R      |= 0x00010000;   					// 2) Activa ADC0 
  for (int i = 0; i < 100; i++){}   						/* wait a while */
      
	ADC0_PC_R &= 0xF0;            
  ADC0_PC_R |= 0x01;             							  		// configure for 125K samples/sec
  
	ADC0_SSPRI_R         = 0x0123;          					// 4) Secuencia 3 de mayor prioridad 
  ADC0_EMUX_R          = 0x0000;         						// 5) seq3 is software trigger
  
	ADC0_SSMUX3_R = (ADC0_SSMUX3_R&0xFFFFFFF0)+0; 		// 6) channel AIN0 (PE3)
  ADC0_SSCTL3_R = 0x0006;         									// 7) no TS0 D0, yes IE0 END0
  ADC0_ACTSS_R |= 0x0008;         									// 8) Promedio on/off Secuencia 3
  
}
