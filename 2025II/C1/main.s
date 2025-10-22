
REGA		EQU		0x20020000

			AREA	|.text|,  CODE, READONLY, ALIGN = 2
			ENTRY
			EXPORT	__main


__main		LDR		R1, = REGA ; CARGAR EL REGISTRO DATA EN R1 
			MOV		R0, #0X0A
			STR		R0, [R1] 
			
			
LOOP		
			B 		LOOP
			
			ALIGN
			END			
				