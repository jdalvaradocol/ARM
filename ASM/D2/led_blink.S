
			.syntax unified
			.text
			.global led_blink

#define 	GPIO_DATA 		R0
#define		DATA 			R1
			
			.thumb_func

led_blink:	
			PUSH 	{LR}  				/* guardamos la direccion de retorno en la pila */		
			
			LDR		R2, [GPIO_DATA]
			EOR		R2, R2, DATA	
			STR		R2, [GPIO_DATA]		
			POP 	{PC}   				/* retorno   */
