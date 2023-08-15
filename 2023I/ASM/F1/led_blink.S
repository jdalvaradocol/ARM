
			.syntax unified
			.text
			.global led_blink
			.thumb_func

#define		GPIO_PORTF_DATA_R	 R0	
#define		COLOR				 R1	

led_blink:	
			PUSH 	{LR}  					/* guardamos la direccion de retorno en la pila */
		
			MOV		R3, COLOR
			LDR     R2, [GPIO_PORTF_DATA_R]
			EOR		R2, R3
			STR		R2, [GPIO_PORTF_DATA_R] 
			
			POP 	{PC}   				/* retorno   */
