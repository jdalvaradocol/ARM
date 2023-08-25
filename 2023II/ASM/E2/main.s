
DATA  	EQU	 	0x20020000

		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main

; R1 = 500 R2 = 1000
; R3 = R1 + R2

__main
		MOV		R1,#500
		MOV		R2,#1000
		
		ADD		R3, R1, R2
		
LOOP		
		B  		LOOP			
		ALIGN
		END			