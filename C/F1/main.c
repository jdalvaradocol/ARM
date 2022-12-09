// PWMtest.c
// Runs on TM4C123
// Use PWM0/PB6 and PWM1/PB7 to generate pulse-width modulated outputs.
// Daniel Valvano
// March 28, 2014

/* This example accompanies the book
   "Embedded Systems: Real Time Interfacing to ARM Cortex M Microcontrollers",
   ISBN: 978-1463590154, Jonathan Valvano, copyright (c) 2014
  Program 6.7, section 6.3.2

 Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu
    You may use, edit, run or distribute this file
    as long as the above copyright notice remains
 THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
 OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 For more information about my classes, my research, and my books, see
 http://users.ece.utexas.edu/~valvano/
 */

#include <stdint.h>
#include "tm4c123gh6pm.h"
#include "PLL.h"
#include "PWM.h"

// FUNCTION PROTOTYPES: Each subroutine defined

void delay_ms(int delay);


int main(void)
{
	uint16_t i;
	
	//PLL_Init();
  PWM0A_Init(40000, 20000);        			// initialize PWM0, 500 Hz, 25% duty
	PWM0B_Init(40000, 10000);        			// initialize PWM0, 500 Hz, 50% duty
		
	while(1)
	{
		for(i=0;i<40000;i+=100)
		{			
		
			PWM0A_Duty(i);			
			PWM0B_Duty(i);
			delay_ms(1);
			
		}
	}
}	

void delay_ms(int delay)
{

	for(int j=0;j<delay;j++)
	{	
		for(int i=0;i<20000;i++)
		{}
	}

}

