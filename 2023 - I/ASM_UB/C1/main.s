DATA0		 	EQU	 0x20000000
DATA1		 	EQU	 0x20000004
DATA2		 	EQU	 0x20000008

				AREA	|.text|, CODE, READONLY, ALIGN = 2
				ENTRY
				EXPORT	__main

; R0 =  5 si R1 = 4
; R0 = 10 si R1 =! 4

__main

				MOV		R1, #0

INICIO			ADD		R1, #1
				USAT	R1, #4, R1	
				CMP		R1,	#4
				BEQ		ES4
				BNE		NOES4		
				
ES4				MOV		R0, #5
				B		INICIO
				
NOES4			MOV		R0, #10
				B		INICIO			
				
				ALIGN
				END	