DATA0		 	EQU	 0x20000000
DATA1		 	EQU	 0x20000004
DATA2		 	EQU	 0x20000008
		
				AREA	|.text|, CODE, READONLY, ALIGN = 2
				ENTRY
				EXPORT	__main

__main

				LDR		R0,  =DATA0		;0x20000000
				MOV		R1,  #0xF0F0
				STR		R1,  [R0]		
				LDR		R2,  [R0]
				
				LDR		R0,  =DATA1		;0x20000004
				MOV		R1,  #0x1111
				STR		R1,  [R0]	
				LDR		R2,  [R0]
				
				LDR		R0,  =DATA2		;0x20000008
				MOV		R1,  #0x1234
				STR		R1,  [R0]	
				LDR		R2,  [R0]
LOOP		

				B       		LOOP			
				ALIGN
				END	