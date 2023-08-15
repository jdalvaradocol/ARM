
			.syntax unified
			.text
			.global init_PORTF
			.thumb_func


init_PORTF:	
			PUSH 	{LR}  					/* guardamos la direccion de retorno en la pila */
		
			LDR		R0, = 0x400FE608	 
			LDR		R1, [R0]				 	
			ORR		R2, R1, #0x20			
			STR     R2, [R0]				
			NOP																				
			NOP							
			NOP							
					
			LDR		R0, = 0x40025520		
			LDR		R1, = 0x4C4F434B		
			STR		R1, [R0]					
		
			LDR		R0, = 0x40025524 
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
			LDR		R0, = 0x40025528
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
			LDR		R0, = 0x4002552C
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
			LDR		R0, = 0x40025400 
			MOV		R1, #0x0E
			STR		R1, [R0] 	

			LDR		R0, = 0x40025420 
			MOV		R1, #0x00
			STR		R1, [R0] 
		
			LDR		R0, = 0x40025510
			MOV		R1, #0x11
			STR		R1, [R0] 
		
			LDR		R0, = 0x4002551C
			MOV		R1, #0x1F
			STR		R1, [R0] 
			
			POP 	{PC}   				/* retorno   */
