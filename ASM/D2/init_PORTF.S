					

			.syntax unified
			.text
			.global init_PORTF
			
			.thumb_func

init_PORTF:	
			PUSH 	{LR}  					/* guardamos la direccion de retorno en la pila */
			
			/*
			 Configuracion del puerto F
			 SYSCTL_RCGCGPIO_R EQU	0x400FE608
			 SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x20	
			*/
			
			LDR		R0, =0x400FE108		
			LDR		R1, [R0]				
			MOV		R2, #0x20					
			ORR		R1, R1, R2						
			STR		R1, [R0]				
			NOP								
			NOP								
			NOP								
			
			/*
			 GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY
			 GPIO_LOCK_KEY EQU 0x4C4F434B  ; Unlocks the GPIO_CR register
			*/
			LDR		R0, =0x40025520
			LDR		R1, =0x4C4F434B
			STR		R1, [R0] 

			/*
			 GPIO_PORTF_CR_R = 0xFF
			 Habilita la escritura en los registros del PORTF		
			 GPIO_PORTF_CR_R	EQU 0x40025524
			*/
			
			LDR		R0, =0x40025524
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
			/*
			 GPIO_PORTF_AMSEL_R = 0x00
			 No activa el modo analogo en PORTF
			 GPIO_PORTF_AMSEL_R 		EQU 	0x40025528
			*/
			
			LDR		R0, =0x40025528
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
			/*
			 GPIO_PORTF_PCTL_R = 0x00000000
			 No activa los perifericos en PORTF
			 GPIO_PORTF_PCTL_R EQU	0x4002552C
			*/
			
			LDR		R0, =0x4002552C
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
			/*
			 GPIO_PORTF_DIR_R = 0x00000000
			 Configura entrada y salidas I/O en PORTF
			 GPIO_PORTF_DIR_R EQU 0x40025400
			 PF4 -   PF3 -   PF2 -   PF1 - PF0
			 SW2 - LED_B - LED_G - LED_R - SW1	
			   0 -     1 -     1 -     1 -   0  = 0x0E 
			
			 0 = ENTRADA
			 1 = SALIDA
			*/
			
			LDR		R0, =0x40025400
			MOV		R1, #0x0E
			STR		R1, [R0] 	
			
			/*
			 GPIO_PORTF_AFSEL_R = 0x00
			 No configura perifericos en el PORTF
			 GPIO_PORTF_AFSEL_R EQU 0x40025420
			*/
			
			LDR		R0, =0x40025420
			MOV		R1, #0x00
			STR		R1, [R0] 
			
			/*
			 GPIO_PORTF_PUR_R = 0x11
			 Habilita las pull-up para PF0 y PF4
			 GPIO_PORTF_PUR_R EQU 0x40025510
			*/
			
			LDR		R0, =0x40025510
			MOV		R1, #0x11
			STR		R1, [R0] 
		
		    /*
			 GPIO_PORTF_DEN_R = 0x1F
			 Habilita modo digital para PF0 a PF4
			 GPIO_PORTF_DEN_R EQU 0x4002551C
			*/
			
			LDR		R0, =0x4002551C
			MOV		R1, #0x1F
			STR		R1, [R0] 
		
			POP 	{PC}   				/* retorno   */
