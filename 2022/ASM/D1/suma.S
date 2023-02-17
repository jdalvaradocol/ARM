			.syntax unified
			.text
			.global suma

#define 	ope1 		R0
#define		ope2 		R1
			
			.thumb_func

suma:	
		PUSH 	{LR}  				/* guardamos la direccion de retorno en la pila */
		ADD 	ope1, ope1, ope2 	/* a = a + b */
		POP 	{PC}   				/* retorno   */
