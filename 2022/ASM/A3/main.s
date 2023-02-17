

VAR1	EQU		0x20000000 
VAR2	EQU		0x20000004 
VAR3	EQU		0x20000008 

		AREA	|.text|, CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT	__main	

; 	VAR1 = 10 VAR2 = 20 VAR3 = 15
; 	VAR3 = VAR1 + VAR2

__main		
		LDR		R0, =VAR1		; *R0 = 0x20000000
		LDR		R1, =VAR2		; *R1 = 0x20000001
		LDR 	R2, =VAR3		; *R2 = 0x20000002
		
LOOP	MOV		R3, #10			; R3 = 10
		MOV		R4, #20			; R4 = 20	
		MOV		R5, #15			; R5 = 15
		STR		R3, [R0]		; Guardar *R0 = R3, VAR1 = R3 
		STR		R4, [R1]		; Guardar *R1 = R4, VAR2 = R4
		STR		R5, [R2]		; Guardar *R2 = R5, VAR3 = R5
		ADD		R5, R4, R3		; R5 = R4 + R3 
		STR		R5, [R2]		; Guardar *R2 = R5, VAR3 = R5		B 		LOOP
		
		B		LOOP			; ETIQUETA LOOP
		
		ALIGN
		END	
		
		