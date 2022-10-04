
CONTA		EQU		0x20000000
CONTB		EQU		0x20000004

			AREA    |.text|, CODE, READONLY, ALIGN=2
			THUMB
			GET 	tm4c123gh6pm.s
			EXPORT  __main
				
			; Configuracion del puerto F
			; SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x20	
			
__main		LDR		R0, =SYSCTL_RCGC2_R		; 	*R0 = SYSCTL_RCGC2_R
			LDR		R1, [R0]				; 	R1 = *R0
			MOV		R2, #0x20				; 	R2 = 0x02	
			ORR		R1, R1, R2				;	R1 = R1 (or) R2		
			STR		R1, [R0]				;	*R0 = R1
			NOP								; 	DELAY 1 CICLO
			NOP								; 	DELAY 1 CICLO
			NOP								;	DELAY 1 CICLO
		
			; GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY
			
			LDR		R0, =GPIO_PORTF_LOCK_R
			LDR		R1, =GPIO_LOCK_KEY
			STR		R1, [R0] 
			
			; GPIO_PORTF_CR_R = 0xFF
			; Habilita la escritura en los registros del PORTF
			LDR		R0, =GPIO_PORTF_CR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
			; GPIO_PORTF_AMSEL_R = 0x00
			; No activa el modo analogo en PORTF
			LDR		R0, =GPIO_PORTF_AMSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
			; GPIO_PORTF_PCTL_R = 0x00000000
			; No activa los perifericos en PORTF
			LDR		R0, =GPIO_PORTF_PCTL_R
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
			; GPIO_PORTF_DIR_R = 0x00000000
			; Configura entrada y salidas I/O en PORTF
			;  F3 -  F2 -  F1 -  F0
			; SW3 - SW2 - SW1 - SW0	
			;  	0 -   0 -   0 -   0 = 0x00 
			
			; 0 = ENTRADA
			; 1 = SALIDA
			
			LDR		R0, =GPIO_PORTF_DIR_R
			MOV		R1, #0x00
			STR		R1, [R0] 	

			; GPIO_PORTF_AFSEL_R = 0x00
			; No configura perifericos en el PORTF
			LDR		R0, =GPIO_PORTF_AFSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
			; GPIO_PORTF_PUR_R = 0x00
			; Configura pull-up para PF0 y PF4
			LDR		R0, =GPIO_PORTF_PUR_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
			; GPIO_PORTF_DEN_R = 0x1F
			; Habilita modo digital para PF0 a PF4
			LDR		R0, =GPIO_PORTF_DEN_R
			MOV		R1, #0x1F
			STR		R1, [R0] 
		
			; Configuracion del puerto B
			; SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x02	
			
			LDR		R0, =SYSCTL_RCGC2_R		; 	*R0 = SYSCTL_RCGC2_R
			LDR		R1, [R0]				; 	R1 = *R0
			MOV		R2, #0x02				; 	R2 = 0x02	
			ORR		R1, R1, R2				;	R1 = R1 (or) R2		
			STR		R1, [R0]				;	*R0 = R1
			NOP								; 	DELAY 1 CICLO
			NOP								; 	DELAY 1 CICLO
			NOP								; 	DELAY 1 CICLO
			
			; GPIO_PORTB_CR_R = 0xFF
			; Habilita la escritura en los registros del PORTB
			LDR		R0, =GPIO_PORTB_CR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
			; GPIO_PORTB_AMSEL_R = 0x00
			; No activa el modo analogo en PORTB
			LDR		R0, =GPIO_PORTB_AMSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
			; GPIO_PORTB_PCTL_R = 0x00000000
			; No activa los perifericos en PORTB
			LDR		R0, =GPIO_PORTB_PCTL_R
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
			; GPIO_PORTB_DIR_R = 0x00000000
			; Configura entrada y salidas I/O en PORTB
			; B7 - B6 - B5 - B4 - B3 - B2 - B1 - B0 
			; dp -  g -  f -  e -  d -  c -  b -  a	
			;  1 -  1 -  1 -  1 -  1 -  1 -  1 -  1 = 0xFF 
			
			; 0 = ENTRADA
			; 1 = SALIDA
			
			LDR		R0, =GPIO_PORTB_DIR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	

			; GPIO_PORTB_AFSEL_R = 0x00
			; No configura perifericos en el PORTB
			LDR		R0, =GPIO_PORTB_AFSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
			; GPIO_PORTB_PUR_R = 0x00
			; Configura pull-up apagadas
			LDR		R0, =GPIO_PORTB_PUR_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
			; GPIO_PORTB_DEN_R = 0xFF
			; Habilita modo digital para PB7 a PB0
			LDR		R0, =GPIO_PORTB_DEN_R
			MOV		R1, #0xFF
			STR		R1, [R0] 
		
			; Configuracion del puerto E
			; SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x10	
		
			LDR		R0, =SYSCTL_RCGC2_R		; 	*R0 = SYSCTL_RCGC2_R
			LDR		R1, [R0]				; 	R1 = *R0
			MOV		R2, #0x10				; 	R2 = 0x02	
			ORR		R1, R1, R2				;	R1 = R1 (or) R2		
			STR		R1, [R0]				;	*R0 = R1
			NOP								; 	DELAY 1 CICLO
			NOP								; 	DELAY 1 CICLO
			NOP								; 	DELAY 1 CICLO
			
			; GPIO_PORTE_CR_R = 0xFF
			; Habilita la escritura en los registros del PORTE
			LDR		R0, =GPIO_PORTE_CR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
			; GPIO_PORTE_AMSEL_R = 0x00
			; No activa el modo analogo en PORTE
			LDR		R0, =GPIO_PORTE_AMSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
			; GPIO_PORTE_PCTL_R = 0x00000000
			; No activa los perifericos en PORTE
			LDR		R0, =GPIO_PORTE_PCTL_R
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
			; GPIO_PORTF_DIR_R = 0x00000000
			; Configura entrada y salidas I/O en PORTE
			;  E5 -  E4 - E3 - E2 -    E1 -    E0 
			; HD3 - HD4 - XX - XX - LED10 - LED09	
			;  	1 -   1 -  0 -  0 -     1 -     1 = 0x33 
			
			; 0 = ENTRADA
			; 1 = SALIDA
			
			LDR		R0, =GPIO_PORTE_DIR_R
			MOV		R1, #0x33
			STR		R1, [R0] 	

			; GPIO_PORTE_AFSEL_R = 0x00
			; No configura perifericos en el PORTE
			LDR		R0, =GPIO_PORTE_AFSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
			; GPIO_PORTE_PUR_R = 0x00
			; Configura pull- up apagado
			LDR		R0, =GPIO_PORTE_PUR_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
			; GPIO_PORTE_DEN_R = 0x33
			; Habilita modo digital para PE5, PE4, PE1, PE0
			LDR		R0, =GPIO_PORTE_DEN_R
			MOV		R1, #0x33
			STR		R1, [R0] 
		
			LDR		R10, =GPIO_PORTB_DATA_R			
			LDR		R11, =GPIO_PORTE_DATA_R			
			LDR		R12, =GPIO_PORTF_DATA_R		

			LDR 	R0, =CONTA 
			MOV		R1,	#0
			STR 	R1, [R0] 

			LDR 	R0, =CONTB 
			MOV		R1,	#0
			STR 	R1, [R0] 

INICIO		B		DIGITOS
SIG			LDR 	R0, =CONTA 
			LDR		R1, [R0]	
			ADD		R1, #1
			STR 	R1, [R0]
			CMP 	R1, #10
			BEQ 	A10
			B		INICIO

A10			MOV		R1,	#0
			STR 	R1, [R0]
			LDR 	R0, =CONTB 
			LDR		R1, [R0]	
			ADD		R1, #1
			STR 	R1, [R0]
			CMP 	R1, #6
			BEQ 	B10
			B		INICIO

B10			MOV		R1,	#0
			STR 	R1, [R0]
			B		INICIO

			; Funcion para realizar la visualización dinamica en dos displays
			; En el display 3 se visualizar el registro CONTB
			; En el display 4 se visualizar el registro CONTA			
			; HD3 = CONTB y HD4 = CONTA 

DIGITOS		MOV		R4, #50
LOOP_DIS	MOV		R0,	#0x10
			STR 	R0, [R11]               
			LDR		R1, =CONTA
			LDR		R0, [R1]	
			BL		DISPLAY
			MOV		R0, #5
			BL		DELAY_MS
		
			MOV		R0,	#0x20
			STR 	R0, [R11]
			LDR		R1, =CONTB
			LDR		R0, [R1]	
			BL		DISPLAY
			MOV		R0, #5
			BL		DELAY_MS		

			SUBS	R4, #0x01
			BNE		LOOP_DIS
			B		SIG	

			; La siguiente funcion lee el valor del registro R0 y reliza el cambio de binario a 7 segmentos
			; el valor salida esta asignado para el GPIO_PORTB_DATA_R = DISPLAY(R0)	

DISPLAY		CMP 	R0, #0x00
			BEQ 	SEG0
			CMP 	R0, #0x01
			BEQ 	SEG1
			CMP 	R0, #0x02
			BEQ 	SEG2
			CMP 	R0, #0x03
			BEQ 	SEG3
			CMP 	R0, #0x04
			BEQ 	SEG4
			CMP 	R0, #0x05
			BEQ 	SEG5
			CMP 	R0, #0x06
			BEQ 	SEG6
			CMP 	R0, #0x07
			BEQ 	SEG7
			CMP 	R0, #0x08
			BEQ 	SEG8
			CMP 	R0, #0x09
			BEQ 	SEG9
			MOV		R1, #0xFF
			STR 	R1, [R10]  
			BX		LR
			
SEG0		MOV		R1, #0x40
			STR 	R1, [R10]               
			BX		LR

SEG1		MOV		R1, #0x79
			STR 	R1, [R10]               
			BX		LR

SEG2		MOV		R1, #0x24
			STR 	R1, [R10]               
			BX		LR

SEG3		MOV		R1, #0x30
			STR 	R1, [R10]               
			BX		LR

SEG4		MOV		R1, #0x19
			STR 	R1, [R10]               
			BX		LR

SEG5		MOV		R1, #0x12
			STR 	R1, [R10]               
			BX		LR

SEG6		MOV		R1, #0x02
			STR 	R1, [R10]               
			BX		LR

SEG7		MOV		R1, #0x78
			STR 	R1, [R10]               
			BX		LR

SEG8		MOV		R1, #0x00
			STR 	R1, [R10]               
			BX		LR

SEG9		MOV		R1, #0x10
			STR 	R1, [R10]               
			BX		LR

			; Funcion realiza un delay aproximado a 1ms 
			; Para una Frecuencia de 16MHz
			; En R0 se configura el tiempo en ms del delay

DELAY_MS	MOV		R1, #5333 
			SUBS 	R0, R0, #1                 
			BNE 	LOOP_MS
			BX  	LR                         
		
LOOP_MS		SUBS 	R1, R1, #1                 
			BNE 	LOOP_MS                    
			B		DELAY_MS
		
			ALIGN                           
			END                            