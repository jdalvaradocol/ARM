DATA0  	EQU	 	0x20000000
DATA1  	EQU	 	0x20000004
DATA2  	EQU	 	0x20000008
DATA3  	EQU	 	0x2000000C

		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main


; DATA0 = 100 
; DATA1 = 66000
; DATA2 = DATA0 * DATA1 
; DATA3 = DATA1 / DATA0 

__main

		LDR 	R0, = DATA0	; Cargar el registro DATA en R0.
		LDR 	R1, = DATA1 ; Cargar el registro DATA en R1.
		LDR 	R2, = DATA2 ; Cargar el registro DATA en R2.
		LDR 	R3, = DATA3 ; Cargar el registro DATA en R3.

		MOV 	R4, #100    ; R4 = 100
		STR 	R4, [R0] 	; Guarda el valor de R3 en DATA0

		MOVW	R4, #464	; R3 = 464
		MOVT	R4, #1 		; R3 = 66000

		STR 	R4, [R1] 	; Guarda el valor de R4 en DATA1
		
		LDR		R4, [R0]	; Lee el valor de DATA0
		LDR		R5, [R1]	; Lee el valor de DATA1	
	
		MUL		R6, R4, R5 	; R5 = R4 (DATA0) * R5 (DATA1)	
		STR 	R6, [R2] 	; Guarda el valor de R6 en DATA2

		USAT	R7, 22, R6 

		UDIV	R6, R5, R4 	; R5 = R5 (DATA1) / R4 (DATA0)
		STR 	R6, [R3] 	; Guarda el valor de R6 en DATA3

LOOP		
		B       LOOP			
		ALIGN
		END