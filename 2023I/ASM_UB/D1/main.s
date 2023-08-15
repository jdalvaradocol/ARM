DATA0		 		EQU	 	0x20000000
DATA1		 		EQU	 	0x20000004
DATA2		 		EQU	 	0x20000008

GPIO_PORTF_DATA_R 	EQU 	0x400253FC
GPIO_PORTF_DIR_R 	EQU 	0x40025400	
GPIO_PORTF_AFSEL_R 	EQU 	0x40025420
GPIO_PORTF_PUR_R 	EQU 	0x40025510
GPIO_PORTF_DEN_R 	EQU 	0x4002551C
GPIO_PORTF_LOCK_R 	EQU 	0x40025520	
GPIO_LOCK_KEY       EQU	   	0x4C4F434B
GPIO_PORTF_CR_R 	EQU 	0x40025524
GPIO_PORTF_AMSEL_R 	EQU 	0x40025528
GPIO_PORTF_PCTL_R 	EQU 	0x4002552C	
SYSCTL_RCGC2_R 		EQU 	0x400FE108	
	
					AREA	|.text|, CODE, READONLY, ALIGN = 2
					ENTRY
					EXPORT	__main

; R0 =  5 si R1 = 4
; R0 = 10 si R1 =! 4

__main
				
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
			
; 					GPIO_PORTF_DIR_R = 0x00000000
; 					Configura entrada y salidas I/O en PORTF
;  					 F4 -   F3 -   F2 -   F1 -  F0
; 		   			SW1 - LEDG - LEDB - LEDR - SW2	
;  			 		  0 -    1 -    1 -    1 -   0 = 0x0E 
; 					0 = ENTRADA
; 					1 = SALIDA
			
					LDR		R0, =GPIO_PORTF_DIR_R
					MOV		R1, #0x0E
					STR		R1, [R0] 	

; 					GPIO_PORTF_AFSEL_R = 0x00
; 					No configura perifericos en el PORTF
					LDR		R0, =GPIO_PORTF_AFSEL_R
					MOV		R1, #0x00
					STR		R1, [R0] 
		
; 					GPIO_PORTF_PUR_R = 0x11
; 					Configura pull-up para PF0 y PF4
					LDR		R0, =GPIO_PORTF_PUR_R
					MOV		R1, #0x11
					STR		R1, [R0] 
		
; 					GPIO_PORTF_DEN_R = 0x1F
; 					Habilita modo digital para PF0 a PF4
					LDR		R0, =GPIO_PORTF_DEN_R
					MOV		R1, #0x1F
					STR		R1, [R0] 
				
					LDR		R12, = GPIO_PORTF_DATA_R			
					
					
INICIO				LDR		R1, [R12]
					MOV		R2, #0x11
					AND		R1, R2

					CMP		R1, #0x01
					BEQ		AZUL

					CMP		R1, #0x10
					BEQ		ROJO

					CMP		R1, #0x00
					BEQ		VERDE

					CMP		R1, #0x11
					BEQ		APAGADO

					B		INICIO


APAGADO				MOV		R0, #0
					STR		R0, [R12]
					B		INICIO
		
AZUL				MOV		R0, #2
					STR		R0, [R12]	
					B		INICIO
					
ROJO				MOV		R0, #4
					STR		R0, [R12]	
					B		INICIO

VERDE				MOV		R0, #8
					STR		R0, [R12]	
					B		INICIO

					ALIGN
					END	