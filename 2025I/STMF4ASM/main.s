
DATA  	EQU	 	0x20020000
DATB  	EQU	 	0x20020004

		AREA	|.text|,  CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main

__main
		LDR 	R1,= DATA     	; Cargar el registro DATA en R0.
		MOV 	R0,#0xBEBE      ; R1 = 10
		STR 	R0,[R1] 		; Guardar el valor de R1 en DATA
		
		LDR 	R2,[R1]     	; Leer el registro y guardarlo en R2.
		

LOOP	MOV		R0,#0x00001111
		MOV		R0,#0x0000FFFF
		MOVW	R0,#0x00005678
		MOVT	R0,#0x00001234

		MOV		R0,#100
		MOV		R1,#200
		ADD		R2,R0,R1		; R2 = R0 + R1  
		
		ADD		R0,#10			; R0 = R0 + 1  
		ADD		R0,R0,#10		; R0 = R0 + 1  

		MOV		R0,#10
		MOV		R1,#20
		
		SUBS	R2,R0,R1		; R2 = R0 - R1
		SBC		R2,R0,R1		; R2 = R0 - R1
		
		MOV		R0,#100
		MOV		R1,#100
		ADD		R2,R0,R1		; R2 = R0 + R1  
		
		USAT	R3,8,R2	
		
		MOV		R0,#100
		MOV		R1,#200
		ADD		R2,R0,R1		; R2 = R0 + R1  
		
		USAT	R3,8,R2	
		
		MOV		R0,3
	
		CBZ		R0, CASO0
	
		CMP		R0,#1
		BEQ		CASO1
		
		CMP		R0,#2
		BEQ		CASO2
		
		CMP		R0,#3
		BEQ		CASO3
		
		B  		LOOP			
		
CASO0	MOV		R1,#0xAA
		B  		LOOP			

CASO1	MOV		R1,#0xBB
		B  		LOOP			

CASO2	MOV		R1,#0xCC
		B  		LOOP			

CASO3	MOV		R1,#0xDD
		B  		LOOP			

		ALIGN
		END	