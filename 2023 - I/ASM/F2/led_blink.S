
			.syntax unified
			.text
			.global led_blink
			.thumb_func

#define		GPIO		 R0	
#define		DATO_SEL	 R1	
#define		COLORA		 R2	
#define		COLORB		 R3	

led_blink:	
			PUSH 	{LR}  					/* guardamos la direccion de retorno en la pila */

			CMP		DATO_SEL, #0x01	
			BEQ		LEDA
			CMP		DATO_SEL, #0x10	
			BEQ		LEDB
			B		APAGADO

APAGADO:	MOV		R5, #0x00
			STR		R5, [GPIO] 
			B		FIN

LEDA:		LDR     R5, [GPIO]
			EOR		R5, COLORA
			STR		R5, [GPIO] 
			B		FIN		

LEDB:		LDR     R5, [GPIO]
			EOR		R5, COLORB
			STR		R5, [GPIO] 

FIN:		POP 	{PC}   				/* retorno   */
