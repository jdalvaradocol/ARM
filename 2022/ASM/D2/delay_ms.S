
			.syntax unified
			.text
			.global delay_ms

#define 	DELAY 		R0
			
			.thumb_func

delay_ms:	
			PUSH 	{LR}  				/* guardamos la direccion de retorno en la pila */		
		
DELAY_MS:	MOVW	R1, 	#5333
			SUBS	DELAY, 	#0x01
			BNE		LOOP_MS		
			B		FIN
			
LOOP_MS:	SUBS	R1, 	#0x01
			BNE		LOOP_MS		
			B		DELAY_MS

FIN:		POP 	{PC}   				/* retorno   */