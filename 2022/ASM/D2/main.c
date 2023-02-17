
#include	"tm4c123gh6pm.h"

#define		ON			1
#define		OFF			0

int main(void)
{	
	init_PORTF();
	
	while(1)
	{
		led_blink(&GPIO_PORTF_DATA_R,0x04);
		delay_ms(300);
	}
	
}
