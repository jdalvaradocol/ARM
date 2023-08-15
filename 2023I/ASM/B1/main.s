DATA0  	EQU	 	0x20000000
DATA1  	EQU	 	0x20000004
DATA2  	EQU	 	0x20000008

		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main


; DATA0 = 100 
; DATA1 = 200
; DATA2 = DATA0 + DATA1 

__main

		LDR 	R0, = DATA0     	; Cargar el registro DATA en R0.
		LDR 	R1, = DATA1     	; Cargar el registro DATA en R1.
		LDR 	R2, = DATA2     	; Cargar el registro DATA en R2.

		MOV 	R3, #100     		; R3 = 100
		STR 	R3, [R0] 			; Guarda el valor de R3 en DATA0

		MOV		R3, #200   			; R3 = 200
		STR 	R3, [R1] 			; Guarda el valor de R3 en DATA1
	
		LDR		R3, [R0]
		LDR		R4, [R1]
	
		ADD		R5, R3, R4 			; R5 = R3 + R4	
		STR 	R5, [R2] 			; Guarda el valor de R5 en DATA2

LOOP		
		B       LOOP			
		ALIGN
		END