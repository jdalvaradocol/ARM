DATA0		 		EQU	 	0x20000000
DATA1		 		EQU	 	0x20000004
DATA2		 		EQU	 	0x20000008
	
					AREA	|.text|, CODE, READONLY, ALIGN = 2
					ENTRY
					GET 	tm4c123gh6pm.s
					EXPORT	__main

__main

; 					CONFIGURACION GPIOB
;					SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x02

					LDR		R0, = SYSCTL_RCGC2_R	; R0 = 0x400FE108	
					LDR		R1, [R0]				; R1 = SYSCTL_RCGC2_R  	
					ORR		R2, R1, #0x02			; R2 = R1 OR 0x02 
					STR     R2, [R0]				; SYSCTL_RCGC2_R = R2 
					NOP								; Delay 1 ciclo													
					NOP								; Delay 1 ciclo
					NOP								; Delay 1 ciclo		
					
;					GPIO_PORTB_CR_R = 0xFF
; 					Habilita la escritura en los registros del PORTF
					LDR		R0, =GPIO_PORTB_CR_R
					MOV		R1, #0xFF
					STR		R1, [R0] 	
					
; 					GPIO_PORTB_AMSEL_R = 0x00
; 					No activa el modo analogo en PORTB
					LDR		R0, =GPIO_PORTB_AMSEL_R
					MOV		R1, #0x00
					STR		R1, [R0] 	
					
;		 			GPIO_PORTB_PCTL_R = 0x00000000
; 					No activa los perifericos en PORTB
					LDR		R0, =GPIO_PORTB_PCTL_R
					MOV		R1, #0x00000000
					STR		R1, [R0] 	
					
; 					GPIO_PORTB_DIR_R = 0x00000000
; 					Configura entrada y salidas I/O en PORTB
; 		 			B7 - B6 - B5 - B4 - B3 - B2 - B1 - B0
;		 		    DP - SG - SF - SE - SD - SC - SB - SA  
;		  			 1 -  1 -  1 -  1 -  1 -  1 -  1 -  1 = 0xFF 
;		 			0 = ENTRADA
;		 			1 = SALIDA
					
					LDR		R0, =GPIO_PORTB_DIR_R
					MOV		R1, #0xFF
					STR		R1, [R0] 	

;		 			GPIO_PORTB_AFSEL_R = 0x00
; 					No configura perifericos en el PORTB
					LDR		R0, =GPIO_PORTB_AFSEL_R
					MOV		R1, #0x00
					STR		R1, [R0] 
				
;	 				GPIO_PORTB_PUR_R = 0x00
; 					Desactiva pull-up para GPIOB
					LDR		R0, =GPIO_PORTB_PUR_R
					MOV		R1, #0x00
					STR		R1, [R0] 
				
;		 			GPIO_PORTB_DEN_R = 0xFF
; 					Habilita modo digital para PB0 a PB7
					LDR		R0, =GPIO_PORTB_DEN_R
					MOV		R1, #0xFF
					STR		R1, [R0]

;					Configuracion del puerto E
;					SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x10;				
				
					LDR		R0, = SYSCTL_RCGC2_R	; R0 = SYSCTL_RCGC2_R
					LDR		R1,	[R0]				; R1 = *SYSCTL_RCGC2_R
					MOV		R2, #0x10				; R2 = 0x10
					ORR		R1, R2					; R1 = R1 or R2 
					STR		R1, [R0]				; R0 = R1
					NOP								; Delay 1 ciclo		
					NOP								; Delay 1 ciclo	
					NOP								; Delay 1 ciclo
									
; 					GPIO_PORTE_CR_R = 0xFF
; 					Habilita la escritura en los registros del PORTB
					LDR		R0, = GPIO_PORTE_CR_R
					MOV		R1, #0xFF
					STR		R1, [R0] 	
			
; 					GPIO_PORTE_AMSEL_R = 0x00
; 					No activa el modo analogo en PORTB
					LDR		R0, =GPIO_PORTE_AMSEL_R
					MOV		R1, #0x00
					STR		R1, [R0] 	
			
; 					GPIO_PORTE_PCTL_R = 0x00000000
; 					No activa los perifericos en PORTB
					LDR		R0, =GPIO_PORTE_PCTL_R
					MOV		R1, #0x00000000
					STR		R1, [R0] 	
			
; 					GPIO_PORTE_DIR_R = 0xFF
; 					Configura como entrada el PORTB
;  					E5 - E4 - E3 - E2 -    E1 -     E0
; 		   			D3 - D4 - A0 - A1 - LED10 -  LED09	 
;  			 		 1 -  1 -  0 -  0 -     1 -      1 = 0x33 
; 					0 = ENTRADA
; 					1 = SALIDA
			
					LDR		R0, =GPIO_PORTE_DIR_R
					MOV		R1, #0x33
					STR		R1, [R0] 	

; 					GPIO_PORTE_AFSEL_R = 0x00
; 					No configura perifericos en el PORTB
					LDR		R0, =GPIO_PORTE_AFSEL_R
					MOV		R1, #0x00
					STR		R1, [R0] 
		
; 					GPIO_PORTE_PUR_R = 0x00
; 					Resistencias de pull-up apagadas 
					LDR		R0, =GPIO_PORTE_PUR_R
					MOV		R1, #0x00
					STR		R1, [R0] 

; 					GPIO_PORTE_DEN_R = 0x1F
; 					Habilita modo digital para PF0 a PF4
					LDR		R0, =GPIO_PORTE_DEN_R
					MOV		R1, #0x3F
					STR		R1, [R0] 


;					Configuracion del puerto F
;					SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x20;				
				
					LDR		R0, = SYSCTL_RCGC2_R	; R0 = SYSCTL_RCGC2_R
					LDR		R1,	[R0]				; R1 = *SYSCTL_RCGC2_R
					MOV		R2, #0x20				; R2 = 0x20
					ORR		R1, R2					; R1 = R1 or R2 
					STR		R1, [R0]				; R0 = R1
					NOP								; Delay 1 ciclo		
					NOP								; Delay 1 ciclo	
					NOP								; Delay 1 ciclo
				
;					Configuracion del GPIO_LOCK
;					GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY

					LDR		R0, = GPIO_PORTF_LOCK_R
					LDR		R1, = GPIO_LOCK_KEY
					STR		R1, [R0]		
					NOP 
					NOP
					NOP
					
; 					GPIO_PORTF_CR_R = 0xFF
; 					Habilita la escritura en los registros del PORTF
					LDR		R0, = GPIO_PORTF_CR_R
					MOV		R1, #0xFF
					STR		R1, [R0] 	
			
; 					GPIO_PORTF_AMSEL_R = 0x00
; 					No activa el modo analogo en PORTF
					LDR		R0, =GPIO_PORTF_AMSEL_R
					MOV		R1, #0x00
					STR		R1, [R0] 	
			
; 					GPIO_PORTF_PCTL_R = 0x00000000
; 					No activa los perifericos en PORTF
					LDR		R0, =GPIO_PORTF_PCTL_R
					MOV		R1, #0x00000000
					STR		R1, [R0] 	
			
; 					GPIO_PORTF_DIR_R = 0x00
; 					Configura como entrada el PORTF
;  					 F4 - F3 - F2 - F1 - F0
; 		   			SW1 - P4 - P3 - P2 - P1	
;  			 		  0 -  0 -  0 -  0 -  0 = 0x00 
; 					0 = ENTRADA
; 					1 = SALIDA
			
					LDR		R0, =GPIO_PORTF_DIR_R
					MOV		R1, #0x00
					STR		R1, [R0] 	

; 					GPIO_PORTF_AFSEL_R = 0x00
; 					No configura perifericos en el PORTF
					LDR		R0, =GPIO_PORTF_AFSEL_R
					MOV		R1, #0x00
					STR		R1, [R0] 
		
; 					GPIO_PORTF_PUR_R = 0x10
; 					Configura pull-up para PF4
					LDR		R0, =GPIO_PORTF_PUR_R
					MOV		R1, #0x00
					STR		R1, [R0] 
		
; 					GPIO_PORTF_DEN_R = 0x1F
; 					Habilita modo digital para PF0 a PF4
					LDR		R0, =GPIO_PORTF_DEN_R
					MOV		R1, #0x1F
					STR		R1, [R0] 
				
					LDR		R10, = GPIO_PORTB_DATA_R			
					LDR		R11, = GPIO_PORTE_DATA_R			
					LDR		R12, = GPIO_PORTF_DATA_R			
					
					MOV		R0, #0x10
					STR		R0, [R11] 
					MOV		R5, #0
				
INICIO				MOV		R0, R5
					BL		DISPLAY
					BL		DELAY
					ADD		R5, #1
					CMP		R5, #10
					BEQ		RESET_U
					B		INICIO

RESET_U				MOV 	R5, #0
					B		INICIO


DISPLAY				CMP		R0, #0x00
					BEQ		CERO
					CMP		R0, #0x01
					BEQ		UNO
					CMP		R0, #0x02
					BEQ		DOS
					CMP		R0, #0x03
					BEQ		TRES
					CMP		R0, #0x04
					BEQ		CUATRO
					CMP		R0, #0x05
					BEQ		CINCO
					CMP		R0, #0x06
					BEQ		SEIS
					CMP		R0, #0x07
					BEQ		SIETE
					CMP		R0, #0x08
					BEQ		OCHO
					CMP		R0, #0x09
					BEQ		NUEVE
					MOV		R1, #0xFF
					STR		R1, [R10]
					BX		LR
					
CERO				MOV		R1, #0x40
					STR		R1, [R10]
					BX		LR

UNO					MOV		R1, #0x79
					STR		R1, [R10]
					BX		LR

DOS					MOV		R1, #0x24
					STR		R1, [R10]
					BX		LR
					
TRES				MOV		R1, #0x30
					STR		R1, [R10]
					BX		LR

CUATRO				MOV		R1, #0x19
					STR		R1, [R10]
					BX		LR
					
CINCO				MOV		R1, #0x12
					STR		R1, [R10]
					BX		LR

SEIS				MOV		R1, #0x02
					STR		R1, [R10]
					BX		LR
				
SIETE				MOV		R1, #0x78
					STR		R1, [R10]
					BX		LR
					
OCHO				MOV		R1, #0x00
					STR		R1, [R10]
					BX		LR					

NUEVE				MOV		R1, #0x10
					STR		R1, [R10]
					BX		LR

DELAY				MOV		R0, #0x0
					MOV		R2, #0xFFFF
					MOVT	R2, #0x0010

LOOP				SUBS	R1, R0, R2 
					BEQ		FIN
					ADD		R0, #1
					B		LOOP
					
FIN					BX		LR					
					

						

					ALIGN
					END	