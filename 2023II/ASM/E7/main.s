
; 0x40022800 - 0x40022BFF GPIOK
; 0x40022400 - 0x400227FF GPIOJ
; 0x40022000 - 0x400223FF GPIOI
; 0x40021C00 - 0x40021FFF GPIOH
; 0x40021800 - 0x40021BFF GPIOG
; 0x40021400 - 0x400217FF GPIOF
; 0x40021000 - 0x400213FF GPIOE
; 0x40020C00 - 0x40020FFF GPIOD
; 0x40020800 - 0x40020BFF GPIOC
; 0x40020400 - 0x400207FF GPIOB
; 0x40020000 - 0x400203FF GPIOA

;------------------------------------------

; 0x40023800 - 0x4002 3BFF RCC
; AHB1 Address offset: 0x30
; RCC_AHB1 0x40023800 + 0x30
; RCC_AHB1 = 0x40023830

RCC_AHB1		EQU		0x40023830
	
;------------------------------------------

; GPIOB base 0x40020400
; GPIOB_MODER Address offset:0x00
; GPIOB_MODER = 0x40020400 

GPIOB_MODER 	EQU		0x40020400

; GPIOB base 0x40020400
; GPIOB_ODR Address offset: 0x14
; GPIOB_ODR = 0x40020414

GPIOB_ODR 		EQU 	0x40020414

; GPIOB base 0x40020400
; GPIOB_IDR Address offset: 0x10
; GPIOB_IDR = 0x40020410

GPIOB_IDR 		EQU 	0x40020410

;------------------------------------------

; GPIOE base 0x40021000
; GPIOE_MODER Address offset:0x00
; GPIOE_MODER = 0x40021000 

GPIOE_MODER 	EQU		0x40021000

; GPIOE base 0x40021000
; GPIOE_ODR Address offset: 0x14
; GPIOE_ODR = 0x40021014

GPIOE_ODR 		EQU 	0x40021014

; GPIOE base 0x40021000
; GPIOE_IDR Address offset: 0x10
; GPIOE_IDR = 0x40021010

GPIOE_IDR 		EQU 	0x40021010
	
;------------------------------------------

; GPIOF base 0x40021400
; GPIOF_MODER Address offset:0x00
; GPIOF_MODER = 0x40021400 

GPIOF_MODER 	EQU		0x40021400

; GPIOF base 0x40021400
; GPIOF_ODR Address offset: 0x14
; GPIOF_ODR = 0x40021414

GPIOF_ODR 		EQU 	0x40021414

; GPIOF base 0x40021400
; GPIOF_IDR Address offset: 0x10
; GPIOF_IDR = 0x40021410

GPIOF_IDR 		EQU 	0x40021410	

;------------------------------------------

; GPIOG base 0x40021800
; GPIOG_MODER Address offset:0x00
; GPIOG_MODER = 0x40021800 

GPIOG_MODER 	EQU		0x40021800

; GPIOG base 0x40021800
; GPIOG_ODR Address offset: 0x14
; GPIOG_ODR = 0x40021814

GPIOG_ODR 		EQU 	0x40021814

; GPIOG base 0x40021800
; GPIOG_IDR Address offset: 0x10
; GPIOG_IDR = 0x40021810

GPIOG_IDR 		EQU 	0x40021810


				AREA	|.text|, CODE, READONLY, ALIGN = 2
				ENTRY
				EXPORT	__main
					
; GPIOx_MODER
; 00 - Input mode
; 01 - General purpose output mode
; 10 - Alternate funcion mode
; 11 - Analog mode

					
__main								

				; Configuracion GPIOB
				; RCC_AHB1 = 0x00000002 

				LDR		R0, = RCC_AHB1
				LDR		R1, [R0]
				ORR		R1, #0x00000002
				STR		R1, [R0]
				
				; PB15 PB14 PB13 PB12 PB11 PB10	PB9	PB8	PB7	PB6	PB5	PB4	PB3	PB2	PB1	PB0
				; XXX  SW6	XXX	 XXX  LED7 LED6	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX
				; GPIOB_MODER = 0x0050 0000

				LDR		R0, =  GPIOB_MODER
				MOVW	R1, #0x0000
				MOVT	R1, #0x0050
				STR		R1, [R0]
				
				; Configuracion GPIOE
				; RCC AHB1 = 0x00000010 

				LDR		R0, = RCC_AHB1
				LDR		R1, [R0]
				ORR		R1, #0x00000010
				STR		R1, [R0]

				; PE15 PE14	PE13 PE12 PE11 PE10 PE9 PE8	 PE7  PE6 PE5 PE4 PE3 PE2 PE1 PE0
				; LED5 LED4	SW4	 LED3 SW2  LED2	SW1	LED0 LED1 XXX XXX XXX XXX XXX XXX XXX
				; GPIOB_MODER = 0x5111 4000					
				
				LDR		R0, =  GPIOE_MODER
				MOVW	R1, #0X4000
				MOVT	R1, #0x5111
				STR		R1, [R0]

				; Configuracion GPIOF
				; RCC AHB1 = 0x00000020 

				LDR		R0, = RCC_AHB1
				LDR		R1, [R0]
				ORR		R1, #0x00000020
				STR		R1, [R0]

				; PF15 PF14 PF13 PF12 PF11 PF10 PF9 PF8	PF7	PF6	PF5	PF4	PF3	PF2	PF1	PF0
				; SW5  SW3	SW0	 XXX  XXX  XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX
				; GPIOF_MODER = 0x00000000				

				LDR		R0, =  GPIOF_MODER
				MOVW	R1, #0X0000
				MOVT	R1, #0x0000
				STR		R1, [R0]

				; Configuracion GPIOG
				; RCC AHB1 = 0x00000040
				
				LDR		R0, = RCC_AHB1
				LDR		R1, [R0]
				ORR		R1, #0x00000040
				STR		R1, [R0]

				; PG15 PG14	PG13 PG12 PG11 PG10 PG9	PG8	PG7 PG6	PG5	PG4	PG3	PG2	PG1	PG0
				; XXX  SW6	XXX	 XXX  XXX  XXX	SW7	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX
				; GPIOG_MODER = 0x00000000	

				LDR		R0, =  GPIOG_MODER
				MOVW	R1, #0X0000
				MOVT	R1, #0x0000
				STR		R1, [R0]
				
				LDR		R8, = GPIOB_ODR
				LDR		R9, = GPIOE_ODR
		
				LDR		R10, = GPIOE_IDR
				LDR		R11, = GPIOF_IDR
				LDR		R12, = GPIOG_IDR
				
LOOP			BL		LECTURA		; R3 almacena el dato de entrada
				
				CMP		R3, #0xF0
				BEQ		RUTINA1
				
				CMP		R3, #0x0F
				BEQ		RUTINA2			
				
				MOV		R0, #0x00
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
			
				B		LOOP

RUTINA1			MOV		R0, #0x01
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
		
				MOV		R0, #0x02
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x04
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x08
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x10
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x20
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x40
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x80
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				B		LOOP

RUTINA2			MOV		R0, #0x81
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x42
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x24
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x18
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x24
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				MOV		R0, #0x42
				BL		ESCRITURA
				MOV		R0, #100
				BL		DELAY_MS
				
				B		LOOP

ESCRITURA		MOV		R2, #0

				; PE8 - LED0
				AND		R1, R0, #0x01
				LSL		R1, #8
				ORR		R2, R1
				; PE7 - LED1
				AND		R1, R0, #0x02
				LSL		R1, #6
				ORR		R2, R1
				; PE10 - LED2
				AND		R1, R0, #0x04
				LSL		R1, #8
				ORR		R2, R1	
				; PE12 - LED3
				AND		R1, R0, #0x08
				LSL		R1, #9
				ORR		R2, R1
				; PE14 - LED4
				AND		R1, R0, #0x10
				LSL		R1, #10
				ORR		R2, R1
				; PE15 - LED5
				AND		R1, R0, #0x20
				LSL		R1, #10
				ORR		R2, R1
				
				; Escritura GPIOE
				STR		R2,[R9]

				MOV		R2, #0

				; PB10 - LED6
				AND		R1, R0, #0x40
				LSL		R1, #4
				ORR		R2, R1
				; PB11 - LED7
				AND		R1, R0, #0x80
				LSL		R1, #4
				ORR		R2, R1
				
				; Escritura GPIOB
				STR		R2,[R8]			

				BX		LR

LECTURA			MOV		R3, #0x00

				;Lectura GPIOF
				LDR		R0,[R11]
				
				; PF13 - SW0
				AND		R1, R0, 0x00002000
				LSR		R1, #13
				ORR		R3, R1

				; PF14 - SW3
				AND		R1, R0, 0x00004000
				LSR		R1, #11
				ORR		R3, R1
				
				; PF15 - SW5
				AND		R1, R0, 0x00008000
				LSR		R1, #10
				ORR		R3, R1

				;Lectura GPIOE
				LDR		R0,[R10]
				
				; PE9 - SW1
				AND		R1, R0, 0x00000200
				LSR		R1, #8
				ORR		R3, R1

				; PE11 - SW2
				AND		R1, R0, 0x00000800
				LSR		R1, #9
				ORR		R3, R1
				
				; PF13 - SW4
				AND		R1, R0, 0x00002000
				LSR		R1, #9
				ORR		R3, R1

				;Lectura GPIOG
				LDR		R0,[R12]
				
				; PG14 - SW6
				AND		R1, R0, 0x00004000
				LSR		R1, #8
				ORR		R3, R1

				; PG9 - SW7
				AND		R1, R0, 0x00000200
				LSR		R1, #2
				ORR		R3, R1

				BX		LR

; 16M - 1600 - 0x3E80

DELAY_MS		MOV		R2, R0

LOOPB			MOV		R1, #0x3E80

LOOPA			SUB		R1, #0x01
				CMP		R1, #0x00
				BNE		LOOPA
				SUB		R2, #0x01
				CMP		R2, #0x00
				BNE		LOOPB
				BX		LR

				ALIGN
				END	
				
				