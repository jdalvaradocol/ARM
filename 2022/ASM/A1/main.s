

DATA  	EQU	 0x20000000

		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main

; Cargar el registro DATA en R0.
; R1 = 10
; R0 = R1
; Guardar el valor de R1 en DATA

__main
	
			LDR		R0, =DATA	;	0x20000000
			MOV		R1, #0xBEBE
			STR		R1, [R0]		

LOOP		
			B       LOOP
			
			ALIGN
			END			
			

