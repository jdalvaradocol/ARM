
REGA		EQU		0x20020000

			AREA	|.text|,  CODE, READONLY, ALIGN = 2
			ENTRY
			EXPORT	__main


__main		LDR		R1, = REGA ; CARGAR EL REGISTRO DATA EN R1 
			MOV		R0, #0X0A
			STR		R0, [R1] 

			; R1 =  R2 + R3
			; R2 = 100
			; R3 = 300

LOOP		MOV		R2, #100
			MOV		R3, #300
			ADD 	R1, R2, R3	

			; R1 = R2 + R3
			; R2 = 500
			; R3 = 200

			MOV		R2, #500
			MOV		R3, #200
			SUB 	R1, R2, R3

			; R1 = R1 + 500
			
			ADD 	R1, #500	
			
			; R1 = R1 + 500
			
			ADD 	R1, R1, #500	

			; R1 = R1 - 100
			
			SUB 	R1, #100	

			; R1 = R1 - 100
			
			SUB 	R1, R1, #100	

			; R5 = 1000000

			MOVW	R5, #0x4240	
			MOVT 	R5, #0xF
			
			; R1 = R2 AND R3
			; R2 = 0x00FF
			; R3 = 0x000F
			
			MOV		R2, #0x00FF
			MOV		R3, #0X000F
			AND 	R1, R2, R3

			; R1 = R2 * R3
			; R2 = 100
			; R3 = 200

			MOV		R2, #100
			MOV		R3, #200
			MUL 	R1, R2, R3
		
			; R1 = R2 / R3
			; R2 = 500
			; R3 = 200

			MOV		R2, #500
			MOV		R3, #200
			UDIV 	R1, R2, R3
			
			; SATURACION 8 bits - 0xFF

			; R1 = 100  
			MOV		R1, #100
			USAT    R0, 8, R1

			; R1 = 255
			MOV		R1, #300
			USAT    R0, 8, R1

			MOVW	R5, #0xFF7F	
			MOVT 	R5, #0xFFFF
			USAT    R0, 8, R1
			
			; BITFIELD
			
			; R4 = 0xFFFFFFFF
			; BORRAR 8 AL 12

			MOVW	R4, #0xFFFF	
			MOVT 	R4, #0xFFFF
			BFC   	R4, #8, #12       

			; R9 = 0x00000000	R2 = 0x12345678
	
			MOV 	R9, #0	
			MOVW	R2, #0x5678	
			MOVT 	R2, #0x1234
			BFI   	R9, R2, #8, #12   	
			
			B 		LOOP
			ALIGN
			END			
				