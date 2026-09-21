#ifndef ST7920_PARALLEL_H_
#define ST7920_PARALLEL_H_

#include "stm32f4xx_hal.h"
#include <stdint.h>

// Control en GPIOC
#define RS_PORT         GPIOC
#define RS_PIN          GPIO_PIN_9

#define RW_PORT         GPIOC
#define RW_PIN          GPIO_PIN_10

#define E_PORT          GPIOC
#define E_PIN           GPIO_PIN_11

// Control y Datos en GPIOD
#define RST_PORT        GPIOD
#define RST_PIN         GPIO_PIN_3

#define DATA_PORT       GPIOD
// DB4=PD7, DB5=PD6, DB6=PD5, DB7=PD4

// Macros de Control
#define RS_HIGH()       HAL_GPIO_WritePin(RS_PORT, RS_PIN, GPIO_PIN_SET)
#define RS_LOW()        HAL_GPIO_WritePin(RS_PORT, RS_PIN, GPIO_PIN_RESET)

#define RW_HIGH()       HAL_GPIO_WritePin(RW_PORT, RW_PIN, GPIO_PIN_SET)
#define RW_LOW()        HAL_GPIO_WritePin(RW_PORT, RW_PIN, GPIO_PIN_RESET)

#define E_HIGH()        HAL_GPIO_WritePin(E_PORT, E_PIN, GPIO_PIN_SET)
#define E_LOW()         HAL_GPIO_WritePin(E_PORT, E_PIN, GPIO_PIN_RESET)

#define RST_HIGH()      HAL_GPIO_WritePin(RST_PORT, RST_PIN, GPIO_PIN_SET)
#define RST_LOW()       HAL_GPIO_WritePin(RST_PORT, RST_PIN, GPIO_PIN_RESET)

// Prototipos
void ST7920_Init(void);
void ST7920_SendCmd(uint8_t cmd);
void ST7920_SendData(uint8_t data);
void ST7920_SendString(int row, int col, char* str);
void ST7920_Clear(void);

void ST7920_GraphicMode(int enable);
void ST7920_Update(void);
void ST7920_ClearBuffer(void);
void SetPixel(uint8_t x, uint8_t y);
void DrawLine(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1);
void DrawRectangle(uint16_t x, uint16_t y, uint16_t w, uint16_t h);
void DrawFilledRectangle(uint16_t x, uint16_t y, uint16_t w, uint16_t h);
void DrawCircle(uint8_t x0, uint8_t y0, uint8_t radius);
void DrawFilledCircle(int16_t x0, int16_t y0, int16_t r);
void DrawTriangle(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t x3, uint16_t y3);
void DrawFilledTriangle(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t x3, uint16_t y3);
void ST7920_DrawBitmap(const uint8_t* graphic);
#endif /* ST7920_PARALLEL_H_ */
