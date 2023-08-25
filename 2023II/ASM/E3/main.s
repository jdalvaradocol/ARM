
DATA  	EQU	 	0x20020000

		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main

; 	Contador de 0 - 59.

; R0 Unidades.
; R1 Decenas.

__main
			MOV		R0,#0
			MOVW	R1,#0	
		
LOOP		MOV		R9, R0
			BL		DISPLAY
			MOV		R2, R10

			MOV		R9, R1
			BL		DISPLAY
			MOV		R3, R10
	
			ADD		R0,#1
			CMP		R0,#10
			BNE		LOOP
			MOV		R0,#0
			ADD		R1,#1
			CMP		R1,#6
			BNE		LOOP
			MOV		R1,#0
			B		LOOP
			
DISPLAY		CMP		R9,#0
			BEQ		CERO
			CMP		R9,#1
			BEQ		UNO
			CMP		R9,#2
			BEQ		DOS
			CMP		R9,#3
			BEQ		TRES
			CMP		R9,#4
			BEQ		CUATRO
			CMP		R9,#5
			BEQ		CINCO
			CMP		R9,#6
			BEQ		SEIS
			CMP		R9,#7
			BEQ		SIETE
			CMP		R9,#8
			BEQ		OCHO
			CMP		R9,#9
			BEQ		NUEVE
			MOV     R10,#0x00
			BX		LR	

CERO		MOV		R10,#0xBF ;0
			BX		LR			
UNO			MOV		R10,#0x86 ; 1
			BX		LR			
DOS			MOV		R10,#0xDB ; 2
			BX		LR			
TRES		MOV		R10,#0xCF ; 3
			BX		LR			
CUATRO		MOV		R10,#0xE6 ; 4
			BX		LR			
CINCO		MOV		R10,#0xED ; 5
			BX		LR			
SEIS		MOV		R10,#0xFD ; 6
			BX		LR			
SIETE		MOV		R10,#0x87 ; 7
			BX		LR			
OCHO		MOV		R10,#0xFF ; 8
			BX		LR			
NUEVE		MOV		R10,#0xEF ; 9
			BX		LR			


			ALIGN
			END			