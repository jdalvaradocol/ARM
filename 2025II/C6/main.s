
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

; GPIOA base 0x40020000
; GPIOA_MODER Address offset 0x00
; GPIOA_MODER = 0x40020000 + 0x00

GPIOA_MODER		EQU		0x40020000

; GPIOA base 0x40020000
; GPIOA_ODR Address offset 0x14
; GPIOA_ODR = 0x40020000 + 0x14
; GPIOA_ODR = 0x40020014

GPIOA_ODR 		EQU		0x40020014

; GPIOA base 0x40020000
; GPIOA_IDR Address offset 0x10
; GPIOA_IDR  = 0x40020000 + 0x10
; GPIOA_IDR -> 0x40020010

GPIOA_IDR 		EQU		0x40020010

;---------------------------------------------------

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

;---------------------------------------------------
	
; GPIOC base 0x40020800
; GPIOC_MODER Address offset 0x00
; GPIOC_MODER = 0x40020800 + 0x00

GPIOC_MODER		EQU		0x40020800

; GPIOC base 0x40020800
; GPIOC_ODR Address offset 0x14
; GPIOC_ODR = 0x40020800 + 0x14
; GPIOC_ODR = 0x40020814

GPIOC_ODR 		EQU		0x40020814

; GPIOC base 0x40020800
; GPIOC_IDR Address offset 0x10
; GPIOC_IDR  = 0x40020800 + 0x10
; GPIOC_IDR -> 0x40020810

GPIOC_IDR 		EQU		0x40020810

;---------------------------------------------------
	
; GPIOD base 0x40020C00
; GPIOD_MODER Address offset 0x00
; GPIOD_MODER = 0x40020C00 + 0x00

GPIOD_MODER		EQU		0x40020C00

; GPIOD base 0x40020C00
; GPIOD_ODR Address offset 0x14
; GPIOD_ODR = 0x40020C00 + 0x14
; GPIOD_ODR = 0x40020C14

GPIOD_ODR 		EQU		0x40020C14

; GPIOD base 0x40020C00
; GPIOD_IDR Address offset 0x10
; GPIOD_IDR  = 0x40020C00 + 0x10
; GPIOD_IDR -> 0x40020C10

GPIOD_IDR 		EQU		0x40020C10

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

;------------------------------------------

				AREA	|.text|, CODE, READONLY, ALIGN = 2
				ENTRY
				EXPORT	__main
					
; GPIOx_MODER
; 00 - Input mode
; 01 - General purpose output mode
; 10 - Alternate funcion mode
; 11 - Analog mode

					
__main								
				; Configuracion GPIOA
				; RCC AHB1 = 0x00000001

				; Habilita GPIOA clock
				LDR		R0, = RCC_AHB1 		;
				LDR		R1, [R0]			; Leer (load) el registro R0 
				ORR		R1, #0x00000001 	
				STR		R1, [R0]

; PA15 PA14	PA13 PA12 PA11 PA10 PA9	PA8	PA7	PA6	PA5	PA4 PA3	PA2	PA1	PA0
; XXX  XXX	XXX	 XXX  XXX  XXX	XXX	XXX	D3	XXX	XXX	XXX	XXX	XXX	XXX	XXX
; GPIOA_MODER = 0x00004000	

				LDR		R0, = GPIOA_MODER 	
				MOVW  	R1, #0x4000	
				MOVT  	R1, #0x0000
				LDR		R2, [R0]
				ORR		R1, R2
				STR		R1, [R0]

				; Configuracion GPIOB
				; RCC_AHB1 = 0x00000002 

				LDR		R0, = RCC_AHB1
				LDR		R1, [R0]
				ORR		R1, #0x00000002
				STR		R1, [R0]
				
; PB15 PB14	PB13 PB12 PB11 PB10	PB9 PB8	PB7 PB6	 PB5 PB4 PB3 PB2  PB1  PB0
; XXX  XXX	XXX	 XXX  LED7 LED6	XXX	XXX	XXX	SD-3 XXX XXX XXX SE-4 DP-7 XXX
; GPIOB_MODER = 0x00501014	

				LDR		R0, = GPIOB_MODER 	
				MOVW  	R1, #0x1014	
				MOVT  	R1, #0x0050
				LDR		R2, [R0]
				ORR		R1, R2
				STR		R1, [R0]

				; Configuracion GPIOC
				; RCC AHB1 = 0x00000004 

				; Habilita GPIOC clock
				LDR		R0, = RCC_AHB1 		
				LDR		R1, [R0]			; Leer (load) el registro R0 
				ORR		R1, #0x00000004 	
				STR		R1, [R0]

; PC15 PC14 PC13 PC12 PC11 PC10	PC9 PC8	PC7	PC6	PC5	PC4	PC3	PC2	 PC1 PC0
; XXX  XXX	XXX	 XXX  XXX  XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	SG-6 XXX XXX
; GPIOC_MODER = 0x00000010				
				
				LDR		R0, = GPIOC_MODER 	
				MOVW  	R1, #0x0010	
				MOVT  	R1, #0x0000
				STR		R1, [R0]

				; Configuracion GPIOD
				; RCC AHB1 = 0x00000008 

				; Habilita GPIOD clock
				LDR		R0, = RCC_AHB1 		
				LDR		R1, [R0]			; Leer (load) el registro R0 
				ORR		R1, #0x00000008 	
				STR		R1, [R0]

; PD15 PD14 PD13 PD12 PD11 PD10 PD9	PD8	PD7 PD6	PD5	PD4	PD3	PD2	PD1	PD0
; D1   D2	SB-1 SF-5 SA-0 XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX	XXX
; GPIOD_MODER = 0x55400000				
				
				LDR		R0, = GPIOD_MODER 	
				MOVW  	R1, #0x0000	
				MOVT  	R1, #0x5540
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

; PF15 PF14	PF13 PF12 PF11 PF10 PF9	PF8	PF7 PF6	PF5	PF4	 PF3 PF2 PF1 PF0
; SW5  SW3	SW0	 D0	  XXX  XXX	XXX	XXX	XXX	XXX	XXX	SC-2 XXX XXX XXX XXX
; GPIOF_MODER = 0x01000100	
			
				LDR		R0, =  GPIOF_MODER
				MOVW	R1, #0x0100
				MOVT	R1, #0x0100
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
				
;------------------------------------------

				; Registros de salida
				LDR		R4, = GPIOA_ODR		; Salida GPIOA
				LDR		R5, = GPIOC_ODR     ; Salida GPIOC
				LDR		R6, = GPIOD_ODR     ; Salida GPIOD
				LDR		R7, = GPIOF_ODR     ; Salida GPIOF 
				LDR		R8, = GPIOB_ODR  	; Salida GPIOB
				
				MOV		R0, #0x80
				STR		R0, [R4]
				
				MOV		R0, #0xC000
				STR		R0, [R6]
				
				MOV		R0, #0x1000
				STR		R0, [R7]
				
				MOV		R11, #0
				MOV		R10, #0
				MOV		 R9, #0
								
LOOP			MOV		R12,#20
				B		REPITE

CONT1			ADD		R11, #1
				CMP		R11, #10
				BNE		LOOP
				
				MOV		R11, #0
				ADD		R10, #1
				CMP		R10, #10
				BNE		LOOP
				
				MOV		 R9, #0
				MOV		 R10, #0
				MOV		 R11, #0
				
				B 		LOOP


REPITE			MOV		R0, #0x80
				STR		R0, [R4]
				MOV		R0, #0x0000
				STR		R0, [R6]
				MOV		R0, #0x0000
				STR		R0, [R7]

				MOV		R0, R11
				BL		DISPLAY
				MOV		R0, R1
				BL		DISPLAYW
				MOV		R0,#1	
				BL		DELAY_MS
		
				MOV		R0, #0x00
				STR		R0, [R4]		
				MOV		R0, #0x4000
				STR		R0, [R6]
				MOV		R0, #0x0000
				STR		R0, [R7]

				MOV		R0, R10
				BL		DISPLAY
				MOV		R0, R1
				BL		DISPLAYW
				MOV		R0,#1					
				BL		DELAY_MS

				MOV		R0, #0x00
				STR		R0, [R4]		
				MOV		R0, #0x8000
				STR		R0, [R6]
				MOV		R0, #0x0000
				STR		R0, [R7]

				MOV		R0, R9
				BL		DISPLAY
				MOV		R0, R1
				BL		DISPLAYW
				MOV		R0,#1					
				BL		DELAY_MS

				MOV		R0, #0x00
				STR		R0, [R4]		
				MOV		R0, #0x0000
				STR		R0, [R6]
				MOV		R0, #0x0000
				STR		R0, [R7]

				MOV		R0, #10
				BL		DISPLAY
				MOV		R0, R1
				BL		DISPLAYW
				MOV		R0,#1					
				BL		DELAY_MS

				MOV		R0, #0x00
				STR		R0, [R4]		
				MOV		R0, #0x0000
				STR		R0, [R6]
				MOV		R0, #0x0000
				STR		R0, [R7]

				MOV		R0, #0xFF
				BL		DISPLAYW
			
				SUB		R12, #0x01
				CMP		R12, #0x00
				BNE		REPITE
								
				B		CONT1


DISPLAY			CMP		R0, #0
				BEQ		CERO
				CMP		R0, #1
				BEQ		UNO
				CMP		R0, #2
				BEQ		DOS
				CMP		R0, #3
				BEQ		TRES
				CMP		R0, #4
				BEQ		CUATRO
				CMP		R0, #5
				BEQ		CINCO
				CMP		R0, #6
				BEQ		SEIS
				CMP		R0, #7
				BEQ		SIETE
				CMP		R0, #8
				BEQ		OCHO
				CMP		R0, #9
				BEQ		NUEVE
				MOV		R1, #0
				BX		LR

CERO			MVN		R1, #0xBF	; 0
				BX		LR
UNO				MVN		R1, #0x86	; 1
				BX		LR
DOS				MVN		R1, #0xDB	; 2
				BX		LR
TRES			MVN		R1, #0xCF	; 3
				BX		LR
CUATRO			MVN		R1, #0xE6	; 4
				BX		LR
CINCO			MVN		R1, #0xED	; 5
				BX		LR
SEIS			MVN		R1, #0xFD	; 6
				BX		LR
SIETE			MVN		R1, #0x87	; 7
				BX		LR
OCHO			MVN		R1, #0xFF	; 8
				BX		LR
NUEVE			MVN		R1, #0xEF	; 9
				BX		LR

DISPLAYW		MOV		R2, #0
				
				; PB1 -> DP7
				AND		R1, R0, #0x80
				LSR		R1, #6
				ORR		R2, R1		
				; PB6 -> SD3
				AND		R1, R0, #0x08
				LSL		R1, #3
				ORR		R2, R1	
				; PB2 -> SE4
				AND		R1, R0, #0x10
				LSR		R1, #2
				ORR		R2, R1	
				
				; Escritura	GPIOB
				LDR		R1, [R8]
				AND		R1, # 0x0C00		
				ORR		R2, R1
				STR		R2, [R8]
				
				MOV		R2, #0

				; PC2 -> SG6
				AND		R1, R0, #0x40
				LSR		R1, #4
				ORR		R2, R1	
				
				; Escritura	GPIOC
				STR		R1, [R5]

				MOV		R2, #0

				; PF4 -> SC2
				AND		R1, R0, #0x04
				LSL		R1, #2
				ORR		R2, R1	
				
				; Escritura	GPIOF
				LDR		R1,[R7]
				AND		R1, #0x1000
				ORR		R2, R1	
				STR		R2, [R7]

				MOV		R2, #0
				
				; PD13 -> SB1
				AND		R1, R0, #0x02
				LSL		R1, #12
				ORR		R2, R1		
				; PD12 -> SF5
				AND		R1, R0, #0x20
				LSL		R1, #7
				ORR		R2, R1	
				; PD11 -> SA0
				AND		R1, R0, #0x01
				LSL		R1, #11
				ORR		R2, R1	
				
				; Escritura	GPIOD
				LDR		R1, [R6]
				AND		R1, # 0xC000		
				ORR		R2, R1
				STR		R2, [R6]
				
				BX 		LR

; 16M - 16000 - 0x3E80

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
				