DATA  	EQU	 	0x20000000
		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main

; R3 = 25
; R4 = 100 
; R5 = 200
; R6 = 400
; R5 = R3 + R4
; R6 = R6 + 100 

__main

		LDR 	R1, = DATA     	; Cargar el registro DATA en R0.
		MOV 	R0, #0x0A       ; R1 = 10
		STR 	R0, [R1] 		; Guardar el valor de R1 en DATA

		MOV		R3, #25			;	R3 = 25
		MOV		R4, #100		;	R4 = 100
		MOV		R5, #200		;	R5 = 200
		MOV		R6, #400		;	R5 = 200

		ADD		R5, R3, R4 		;	R5 = R3 + R4	
		ADD		R6, R6, #100	;	R6 = R6 + 100	
		ADD		R6, #100 		;	R6 = R6 + 100	

LOOP		
		B       LOOP			
		ALIGN
		END