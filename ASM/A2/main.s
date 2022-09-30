

DATA	EQU	 	0x20000000


		AREA    |.text|, CODE, READONLY, ALIGN=2
		ENTRY
		EXPORT  __main
				
__main
		LDR 		R0, =DATA          
LOOP
		ADD		R1, #0x01          
		STR		R1, [R0]

		CMP		R1, #10
		BEQ		SI10		
		B   		LOOP

SI10   	
		BFC		R1, #0, #4
		CBZ		R1, LOOPA
		B   		SI10


LOOPA
		B		LOOP

		ALIGN                           
		END                            
