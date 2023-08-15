VARA  	EQU	 	0x20000000
VARB  	EQU	 	0x20000004


		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main

; DATA0 = 100 
; DATA1 = 66000
; DATA2 = DATA0 * DATA1 
; DATA3 = DATA1 / DATA0 

__main

		LDR 	R0, = VARA	; Carga la posicion de memoria del registro VARA en R0.
		LDR 	R1, = VARB  ; Carga la posicion de memoria del registro VARB en R1.
		
		MOV 	R2, #0    	; R2 = 0
		MOV 	R3, #0    	; R3 = 0
		STR 	R2, [R0] 	; Guarda el valor de R2 en VARA
		STR 	R2, [R1] 	; Guarda el valor de R2 en VARB

LOOP	STR 	R2, [R0] 	; Guarda el valor de R2 en VARA
		STR 	R3, [R1] 	; Guarda el valor de R3 en VARB
		ADD		R2, #1
		CMP		R2, #10
		BEQ		UNIDAD
		B		LOOP

UNIDAD	MOV 	R2, #0    	; R2 = 0
		ADD		R3, #1
		CMP		R3, #6
		BEQ		DECENA
		B		LOOP

DECENA	MOV 	R3, #0    	; R3 = 0	
		B		LOOP

		ALIGN
		END