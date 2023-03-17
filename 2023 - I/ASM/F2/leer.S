
			.syntax unified
			.text
			.global leer
			.thumb_func

#define		GPIO_PORTF_DATA_R	 R0	

leer:	
			PUSH 	{LR}  					/* guardamos la direccion de retorno en la pila */
		
			LDR     R1, [GPIO_PORTF_DATA_R]
			AND     R1, 0x11
			MOV		R0, R1
			STR		R2, [GPIO_PORTF_DATA_R] 
			
			POP 	{PC}   				/* retorno   */
