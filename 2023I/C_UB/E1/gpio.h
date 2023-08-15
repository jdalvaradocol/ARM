

#ifndef __GPIO_H__
#define __GPIO_H__

#define 	ROJO			0x02
#define 	AZUL  		0x04
#define 	VERDE 		0x08
#define 	MORADO		0x06
#define 	MAGENTA		0x0C
#define 	AMARRILLO	0x0A
#define 	BLANCO		0x0E
#define 	APAGADO		0x00

#define 	P1_ON			0x01
#define 	P2_ON			0x02
#define 	P3_ON			0x04
#define 	P4_ON			0x08

// Prototipo de las funciones

void GPIOB_init(void);
void GPIOD_init(void);
void GPIOE_init(void);
void GPIOF_init(void);

#endif // __GPIO_H__
