
REGA		EQU		0x20020000

			AREA	|.text|,  CODE, READONLY, ALIGN = 2
			ENTRY
			EXPORT	__main


__main		MOV		R0, #0


;			SI  R1 = 10 --> R5 = 1
;			SI	R1 = 20 --> R5 = 2
;           SI NO 		 --> R5 = 3				

LOOP		CMP		R0, #10
			BEQ		CIEN		
			B		NOCIEN

NOCIEN		CMP		R0, #20
			BEQ		DOCIENTOS		
			B		NDOCIENTOS

CIEN		MOV		R5, #1
			ADD		R0,#1
			B 		LOOP

DOCIENTOS  	MOV		R5, #2
			ADD		R0,#1
			B 		LOOP

NDOCIENTOS 	MOV		R5, #3
			ADD		R0,#1
			B 		LOOP
			
			ALIGN
			END			
				