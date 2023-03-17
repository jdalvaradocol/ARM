
#include "tm4c123gh6pm.h"

extern void init_PORTF(void);
extern void delay_ms(volatile unsigned long R0);
extern void led_blink(volatile unsigned long *GPIO, int DATO_SEL, int COLORA, int COLORB);
extern int leer(volatile unsigned long *R0);

int main (void)
{	
	int a = 0;

	init_PORTF();

	while(1)
	{
		
		a = leer(&GPIO_PORTF_DATA_R);
		
		led_blink(&GPIO_PORTF_DATA_R, a, 0x02, 0x04);
		delay_ms(500);
				
	}
	
}
