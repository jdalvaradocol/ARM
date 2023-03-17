
			.syntax unified
			.text
			.global delay_ms
			.thumb_func


delay_ms:	
			PUSH 	{LR}  					/* guardamos la direccion de retorno en la pila */
		
DELAY:		
			MOV		R1, #5333 
			SUBS 	R0, R0, #1                 
			BNE 	LOOP_MS
			POP 	{PC}   					/* retorno   */
		
LOOP_MS:	
			SUBS 	R1, R1, #1                 
			BNE 	LOOP_MS                    
			B		DELAY
			
