/*   */

.syntax unified
.cpu cortex-m4
.thumb

.global 	asm_main
.type 		asm_main, %function

.section .text

.equ	DATOA,	100
.equ	DATOB,	200
.equ	DATOC,	300
.equ	DATOD,	4090
.equ	DATOE,	0
.equ	DATOF,	0x12345678

asm_main:

LOOP:
		LDR		R0, =DATOA
		LDR		R1, =DATOB
		LDR		R2, =DATOC

		ADC		R3,R1,R2	// R3 = R1 + R2
		ADC		R2,R1	    // R2 = R2 + R1
		ADC		R3,#100		// R3 = R3 + 100

		LDR		R0, =DATOA
		LDR		R1, =DATOB
		LDR		R2, =DATOC

		ADD		R3,R1,R2	// R3 = R1 + R2
		ADD		R2,R1	    // R2 = R2 + R1
		ADD		R3,#100		// R3 = R3 + 100

		LDR		R4, =DATOD
		ADDW	R6, R4, #4095

		AND		R7, R1, R2

		LDR		R0, =DATOF

		ASR		R9, R0, #4

		LSR		R10, R0, #4

		LDR		R0, =DATOF
		
		MOV		R0, #0xFFFF

		MOVW	R0, #0x5678
		MOVT	R0, #0x1234


		B		LOOP
		


.size asm_main, .-asm_main
