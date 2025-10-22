
REGA		EQU		0x20020000

			AREA	|.text|,  CODE, READONLY, ALIGN = 2
			ENTRY
			EXPORT	__main


__main		MOV		R0, #0

;			SI  R1 = 10 --> RUTINA POR R5 0 AL 4 
;			SI	R1 = 20 --> RUTINA POR R5 5 AL 9 
;           SI NO 		--> R = 0					

LOOP		CMP		R0, #5
			BEQ		CASO1		
			CMP		R0, #10
			BEQ		CASO2		
			
LOOPA		MOV		R5, #15
			ADD		R0, #1
			B 		LOOP
			

CASO1		BL		RUTINA1		
			B 		LOOPA

CASO2		BL		RUTINA2		
			B 		LOOPA

RUTINA1 	MOV		R5, #0
			MOV		R5, #1
			MOV		R5, #2
			MOV		R5, #3
			MOV		R5, #4
			BX		LR

RUTINA2 	MOV		R5, #5
			MOV		R5, #6
			MOV		R5, #7
			MOV		R5, #8
			MOV		R5, #9
			BX		LR
			

			ALIGN
			END			
				