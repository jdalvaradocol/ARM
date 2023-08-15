
#include "tm4c123gh6pm.h"

extern void init_PORTF(void);
extern void delay_ms(volatile unsigned long R0);
extern void led_blink(volatile unsigned long *R0, volatile unsigned long R1);
extern int leer(volatile unsigned long *R0);

void	led_blink_C(volatile unsigned long *PORTF);
void	delay_ms_C(int delay);

int main (void)
{	
	int a = 100;

	init_PORTF();

	while(1)
	{
		
		a = leer(&GPIO_PORTF_DATA_R);
		
		led_blink(&GPIO_PORTF_DATA_R, 0x04);
		delay_ms(500);

		led_blink_C(&GPIO_PORTF_DATA_R);
		delay_ms_C(500);
		
		
	}
	
}

void	led_blink_C(volatile unsigned long *PORTF)
{
	*PORTF = *PORTF ^ 0x06; 
}

void	delay_ms_C(int delay)
{
	for(int j=0;j <delay; j++)
	{
		for(int i=0;i < 5333; i++)
		{}
	}
}
