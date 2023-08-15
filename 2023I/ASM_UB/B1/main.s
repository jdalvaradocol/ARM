DATA0		 	EQU	 0x20000000
DATA1		 	EQU	 0x20000004
DATA2		 	EQU	 0x20000008
		
				AREA	|.text|, CODE, READONLY, ALIGN = 2
				ENTRY
				EXPORT	__main

; DATA0 = DATA1 + DATA2

__main

				LDR		R0,  =DATA0	; 0x20000000
				MOV		R1,  #0x05	;    R1 = 0x05
				STR		R1,  [R0]	; DATA0 = R1 
				LDR		R2,  [R0]	;    R2 = DATA0
				
				LDR		R0,  =DATA1	; 0x20000004
				MOV		R1,  #0x04	;    R1 = 0x04
				STR		R1,  [R0]	; DATA1 = R1
				LDR		R2,  [R0]	;    R2 = DATA1
				
				LDR		R0,  =DATA2	; 0x20000008
				MOV		R1,  #0x02	;    R1 = 0x02	
				STR		R1,  [R0]	; DATA2 = R1	
				LDR		R3,  [R0]	;    R3 = DATA2

				ADD		R4, R2, R3	; R4 = R2 + R3
				
				LDR		R0,  =DATA0	; 0x20000000
				STR		R4,  [R0]	; DATA0 = R4
				
LOOP		

				B       		LOOP			
				ALIGN
				END	