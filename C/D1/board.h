
#ifndef __board_H__
#define __board_H__


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

/* Prototipo de la funcion */
void board_init(void);
int Lectura(void);
void delay_ms(int delay);

#endif // __board_H__