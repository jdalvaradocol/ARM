VARA  	EQU	 	0x20000000
VARB  	EQU	 	0x20000004


			AREA	|.text|,  CODE, READONLY, ALIGN = 2
			ENTRY
			GET 	tm4c123gh6pm.s
			EXPORT	__main

__main


; 			CONFIGURACION GPIOB
;			SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x02

			LDR		R0, = SYSCTL_RCGC2_R	; R0 = 0x400FE108	
			LDR		R1, [R0]				; R1 = SYSCTL_RCGC2_R  	
			ORR		R2, R1, #0x02			; R2 = R1 OR 0x02 
			STR     R2, [R0]				; SYSCTL_RCGC2_R = R2 
			NOP								; Delay 1 ciclo													
			NOP								; Delay 1 ciclo
			NOP								; Delay 1 ciclo		
			
;			GPIO_PORTB_CR_R = 0xFF
; 			Habilita la escritura en los registros del PORTF
			LDR		R0, =GPIO_PORTB_CR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
; 			GPIO_PORTB_AMSEL_R = 0x00
; 			No activa el modo analogo en PORTB
			LDR		R0, =GPIO_PORTB_AMSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
; 			GPIO_PORTB_PCTL_R = 0x00000000
; 			No activa los perifericos en PORTB
			LDR		R0, =GPIO_PORTB_PCTL_R
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
; 			GPIO_PORTB_DIR_R = 0x00000000
; 			Configura entrada y salidas I/O en PORTB
;  			B7 - B6 - B5 - B4 - B3 - B2 - B1 - B0
; 		    DP - SG - SF - SE - SD - SC - SB - SA  
;  			 1 -  1 -  1 -  1 -  1 -  1 -  1 -  1 = 0xFF 
; 			0 = ENTRADA
; 			1 = SALIDA
			
			LDR		R0, =GPIO_PORTB_DIR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	

; 			GPIO_PORTB_AFSEL_R = 0x00
; 			No configura perifericos en el PORTB
			LDR		R0, =GPIO_PORTB_AFSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
; 			GPIO_PORTD_PUR_R = 0x00
; 			Desactiva pull-up para GPIOB
			LDR		R0, =GPIO_PORTB_PUR_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
; 			GPIO_PORTB_DEN_R = 0xFF
; 			Habilita modo digital para PB0 a PB7
			LDR		R0, =GPIO_PORTB_DEN_R
			MOV		R1, #0xFF
			STR		R1, [R0]


; 			CONFIGURACION GPIOD
;			SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x08

			LDR		R0, = SYSCTL_RCGC2_R	; R0 = 0x400FE108	
			LDR		R1, [R0]				; R1 = SYSCTL_RCGC2_R  	
			ORR		R2, R1, #0x08			; R2 = R1 OR 0x08 
			STR     R2, [R0]				; SYSCTL_RCGC2_R = R2 
			NOP								; Delay 1 ciclo													
			NOP								; Delay 1 ciclo
			NOP								; Delay 1 ciclo		

;			GPIO_PORTD_LOCK_R = GPIO_LOCK_KEY 
		
			LDR		R0, = GPIO_PORTD_LOCK_R		; R0 = 0x40025520	
			LDR		R1, = GPIO_LOCK_KEY			; R1 = 0x4C4F434B	
			STR		R1, [R0]					; R0 = R1

;			GPIO_PORTD_CR_R = 0xFF
; 			Habilita la escritura en los registros del PORTD
			LDR		R0, =GPIO_PORTD_CR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
; 			GPIO_PORTD_AMSEL_R = 0x00
; 			No activa el modo analogo en PORTB
			LDR		R0, =GPIO_PORTD_AMSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
; 			GPIO_PORTD_PCTL_R = 0x00000000
; 			No activa los perifericos en PORTB
			LDR		R0, =GPIO_PORTD_PCTL_R
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
; 			GPIO_PORTD_DIR_R = 0x00000000
; 			Configura entrada y salidas I/O en PORTB
;  			  D7 -   D6 - D5 - D4 - D3 - D2 - D1 - D0
; 		    DIG1 - DIG2 - XX - XX - R3 - R2 - R1 - R0  
;  			   1 -    1 -  0 -  0 -  1 -  1 -  1 -  1 = 0xCF 
; 			0 = ENTRADA
; 			1 = SALIDA
			
			LDR		R0, =GPIO_PORTD_DIR_R
			MOV		R1, #0xCF
			STR		R1, [R0] 	

; 			GPIO_PORTD_AFSEL_R = 0x00
; 			No configura perifericos en el PORTD
			LDR		R0, =GPIO_PORTD_AFSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
; 			GPIO_PORTD_PUR_R = 0x00
; 			Desactiva pull-up para GPIOD
			LDR		R0, =GPIO_PORTD_PUR_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
; 			GPIO_PORTD_DEN_R = 0xFF
; 			Habilita modo digital para PD0 a PD7
			LDR		R0, =GPIO_PORTD_DEN_R
			MOV		R1, #0xFF
			STR		R1, [R0]

; 			CONFIGURACION GPIOF
;			SYSCTL_RCGC2_R = SYSCTL_RCGC2_R or 0x20

			LDR		R0, = SYSCTL_RCGC2_R	; R0 = 0x400FE108	
			LDR		R1, [R0]				; R1 = SYSCTL_RCGC2_R  	
			ORR		R2, R1, #0x20			; R2 = R1 OR 0x20 
			STR     R2, [R0]				; SYSCTL_RCGC2_R = R2 
			NOP								; Delay 1 ciclo													
			NOP								; Delay 1 ciclo
			NOP								; Delay 1 ciclo		
			
;			GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY 
		
			LDR		R0, = GPIO_PORTF_LOCK_R		; R0 = 0x40025520	
			LDR		R1, = GPIO_LOCK_KEY			; R1 = 0x4C4F434B	
			STR		R1, [R0]					; R0 = R1
		
; 			GPIO_PORTF_CR_R = 0xFF
; 			Habilita la escritura en los registros del PORTF
			LDR		R0, =GPIO_PORTF_CR_R
			MOV		R1, #0xFF
			STR		R1, [R0] 	
			
; 			GPIO_PORTF_AMSEL_R = 0x00
; 			No activa el modo analogo en PORTF
			LDR		R0, =GPIO_PORTF_AMSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 	
			
; 			GPIO_PORTF_PCTL_R = 0x00000000
; 			No activa los perifericos en PORTF
			LDR		R0, =GPIO_PORTF_PCTL_R
			MOV		R1, #0x00000000
			STR		R1, [R0] 	
			
; 			GPIO_PORTF_DIR_R = 0x00000000
; 			Configura entrada y salidas I/O en PORTF
;  			F4 -   F3 -   F2 - 	 F1 -  F0
; 		   SW1 -   P4 -   P3 -   P2 -  P1	
;  			 0 -    0 -   0 -    0 -   0 = 0x00 
			; 0 = ENTRADA
			; 1 = SALIDA
			
			LDR		R0, =GPIO_PORTF_DIR_R
			MOV		R1, #0x00
			STR		R1, [R0] 	

; 			GPIO_PORTF_AFSEL_R = 0x00
; 			No configura perifericos en el PORTF
			LDR		R0, =GPIO_PORTF_AFSEL_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
; 			GPIO_PORTF_PUR_R = 0x00
; 			Desactiva pull-up para GPIOF	
			LDR		R0, =GPIO_PORTF_PUR_R
			MOV		R1, #0x00
			STR		R1, [R0] 
		
; 			GPIO_PORTF_DEN_R = 0x1F
; 			Habilita modo digital para PF0 a PF4
			LDR		R0, =GPIO_PORTF_DEN_R
			MOV		R1, #0x1F
			STR		R1, [R0] 

			LDR		R10, =GPIO_PORTB_DATA_R			
			LDR		R11, =GPIO_PORTD_DATA_R			
			LDR		R12, =GPIO_PORTF_DATA_R			
			
			MOV		R4,#0
			MOV		R5,#0

INICIO		BL		DIS_VIS
			ADD		R4, #1
			CMP		R4,#10
			BEQ		RESETA
			B		INICIO

RESETA		MOV		R4,#0
			ADD		R5,#1
			CMP		R5,#6
			BEQ		RESETB
			B		INICIO

RESETB		MOV		R5,#0
			B		INICIO

DIS_VIS		MOV		R6, #0
			MOV		R7,	LR	
			
LOOPV		MOV		R0, R4
			BL		DISPLAY
			MOV		R3, #0x40
			STR		R3, [R11]
			MOV		R0, #3 
			BL		DELAY_MS
			
			MOV		R0, R5
			BL		DISPLAY
			MOV		R3, #0x80
			STR		R3, [R11]
			MOV		R0, #3 
			BL		DELAY_MS		
			
			ADD		R6, #1
			CMP		R6, #200
			BEQ		FINV
			B		LOOPV
			
FINV		BX		R7

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

;			for(i=0;0<numero;i++)
;			{}
;

DELAY		MOVW	R7,	#0
			MOVT	R7,	#100
			MOV		R6,	#0

LOOPD		SUBS	R6, R7
			BEQ		FIN
			ADD		R6, #1
			B		LOOPD
FIN			BX		LR

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

			ALIGN	
			END