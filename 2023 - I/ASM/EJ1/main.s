DATA  	EQU	 	0x20000000
		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main

__main

		LDR 	R1, = DATA     	; Cargar el registro DATA en R0.
		MOV 	R0, #0x0A       ; R1 = 10
		STR 	R0, [R1] 		; Guardar el valor de R1 en DATA

		LDR		R0,  =DATA		;0x20000000
		MOV		R1,  #0xBEBEBEBE
		STR		R1,  [R0]		
LOOP		
		B       LOOP			
		ALIGN
		END