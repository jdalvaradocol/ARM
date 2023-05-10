

#ifndef __DISPLAY_H__
#define __DISPLAY_H__

// Declaracion de etiquetas

#define DISPLAY			GPIO_PORTB_DATA_R		
#define DIG1DIG2		GPIO_PORTD_DATA_R		
#define DIG3DIG4		GPIO_PORTE_DATA_R		

// Prototipo de las funciones

int contador_estado(int contador, unsigned long entrada);	
unsigned long display(int numero);	
void visualizar(int numero, int delay);	

#endif // __DISPLAY_H__

