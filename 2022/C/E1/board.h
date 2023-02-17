

#ifndef __board_H
#define __board_H

#include "stdint.h"

#define TRUE 		1 
#define FALSE 	0

enum {
	OFF,
	ON
};


void board_init(void);
void gpioWrite(uint8_t bit, uint8_t dato);
uint8_t gpioRead(uint8_t bit);


#endif // __board_H
