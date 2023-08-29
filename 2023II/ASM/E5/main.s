
; RCC base 0x40023800
; RCC AHB1 Address offset: 0x30
; RCC AHB1 = 0x40023800 + 0x30
; RCC AHB1 -> 0x40023830 
; RCC AHB1 = 0x00000002 

; GPIOx_MODER
; 00 - Input mode
; 01 - General purpose output mode
; 10 - Alternate funcion mode
; 11 - Analog mode

; GPIOB base 0x40020400
; GPIOB_MODER Address offset:0x00
; GPIOB_MODER = 0x40020400 + 0x00
; GPIOB_MODER -> 0x40020400
; GPIOB_MODER = 0x10004001
; LED0 PB0 - LED1 PB7 - LED PB14

; GPIOB base 0x40020400
; GPIOB_ODR Address offset:0x14
; GPIOB_ODR = 0x40020400 + 0x14
; GPIOB_ODR = 0x40020414

; GPIOC base 0x40020800
; GPIOB_MODER Address offset:0x00
; GPIOB_MODER = 0x40020800 + 0x00
; GPIOB_MODER -> 0x40020800
; GPIOB_MODER = 0x00000000
; SW1 PC13

; GPIOC base 0x40020800
; GPIOC_IDR Address offset:0x10
; GPIOC_IDR  = 0x40020800 + 0x10
; GPIOC_IDR -> 0x40020810

RCC_AHB1		EQU		0x40023830
GPIOB_MODER		EQU		0x40020400
GPIOB_ODR 		EQU		0x40020414
GPIOC_MODER		EQU		0x40020800
GPIOC_IDR 		EQU		0x40020810


				AREA	|.text|,  CODE, READONLY, ALIGN = 2
				ENTRY
				EXPORT	__main
			
__main			; Habilita GPIOB clock
				LDR		R0, = RCC_AHB1 		; #0x40023830
				LDR		R1, [R0]			; Leer (load) el registro R0 
				ORR		R1, #0x00000002 	
				STR		R1, [R0]
				
				; Configurar PB0 PB7 PB14 salida
				LDR		R0, = GPIOB_MODER 	; #0x40020400
				MOVW  	R1, #0x4001	
				MOVT  	R1, #0x1000
				STR		R1, [R0]
				
				; Habilita GPIOC clock
				LDR		R0, = RCC_AHB1 		; #0x40023830
				LDR		R1, [R0]			; Leer (load) el registro R0 
				ORR		R1, #0x00000004 	
				STR		R1, [R0]
				
				; Configurar PB13 como entrada.
				LDR		R0, = GPIOC_MODER 	; #0x40020400
				MOV  	R1, #0x00000000
				STR		R1, [R0]
				
				LDR		R10, = GPIOB_ODR 	; #0x40020414
				LDR		R11, = GPIOC_IDR 	; #0x40020414
				
LOOP			LDR		R1, [R11]			; Lee el valor 
				AND		R1, #0x00002000
				
				CMP		R1, #0x00002000 	
				BEQ		RUTINA
				B		LOOP
				
RUTINA
				MOV		R0, #0x00000001
				STR		R0, [R10]
				MOV		R0, #25
				BL		DELAY_MS
				
				MOV		R0, #0x00000080
				STR		R0, [R10]
				MOV		R0, #25
				BL		DELAY_MS
				
				MOV		R0, #0x00004000
				STR		R0, [R10]
				MOV		R0, #25
				BL		DELAY_MS
				
				MOV		R0, #0x00000000
				STR		R0, [R10]
				MOV		R0, #25
				BL		DELAY_MS
				
				B		LOOP

; 1600 -- 3E80

DELAY_MS		
LOOPB			MOV		R1,	#0x3E80		

LOOPA			SUB		R1, #0x01
				CMP		R1, #0x00
				BNE		LOOPA
				SUB		R0, #0x01
				CMP		R0, #0x00
				BNE		LOOPB
				BX		LR
		
				ALIGN
				END				
			