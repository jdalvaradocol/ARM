#include "ST7920_parallel.h"

uint8_t Graphic_Check = 0;
uint8_t image[(128 * 64) / 8];
uint8_t numRows = 64;
uint8_t numCols = 128;

static void DWT_Init(void) {
    if (!(CoreDebug->DEMCR & CoreDebug_DEMCR_TRCENA_Msk)) {
        CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    }
    DWT->CYCCNT = 0;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
}

static void DelayUs(uint32_t us) {
    // 16 ciclos de reloj representan 1 microsegundo a 16 MHz
    volatile uint32_t count = us * 3;
    while (count--) {
        __NOP();
    }
}

static void SendNibble(uint8_t nibble) {
    uint8_t b7 = (nibble & 0x80) ? 1 : 0; // PD4 (DB7)
    uint8_t b6 = (nibble & 0x40) ? 1 : 0; // PD5 (DB6)
    uint8_t b5 = (nibble & 0x20) ? 1 : 0; // PD6 (DB5)
    uint8_t b4 = (nibble & 0x10) ? 1 : 0; // PD7 (DB4)

    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_4, b7 ? GPIO_PIN_SET : GPIO_PIN_RESET);
    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_5, b6 ? GPIO_PIN_SET : GPIO_PIN_RESET);
    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_6, b5 ? GPIO_PIN_SET : GPIO_PIN_RESET);
    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_7, b4 ? GPIO_PIN_SET : GPIO_PIN_RESET);

    DelayUs(2);
    E_HIGH();
    DelayUs(5);
    E_LOW();
    DelayUs(2);
}

void ST7920_SendCmd(uint8_t cmd) {
    RS_LOW();
    RW_LOW();

    SendNibble(cmd & 0xF0);         // Nibble Alto
    SendNibble((cmd << 4) & 0xF0);  // Nibble Bajo

    if (cmd == 0x01) {
        HAL_Delay(15);
    } else {
        DelayUs(80);
    }
}

void ST7920_SendData(uint8_t data) {
    RS_HIGH();
    RW_LOW();

    SendNibble(data & 0xF0);         // Nibble Alto
    SendNibble((data << 4) & 0xF0);  // Nibble Bajo

    DelayUs(80);
}

void ST7920_Init(void) {
    // 1. Iniciar temporizador
    DWT_Init();

    // 2. Reset por Hardware obligatorio
    RST_LOW();
    HAL_Delay(100);
    RST_HIGH();
    HAL_Delay(100);

    RS_LOW();
    RW_LOW();

    // --- SECUENCIA DE ENGANCHE OBLIGATORIA (8-bit -> 4-bit) ---
    // Enviar nibble 0x30 tres veces usando un solo pulso de 'E'
    SendNibble(0x30);
    HAL_Delay(15);

    SendNibble(0x30);
    HAL_Delay(5);

    SendNibble(0x30);
    HAL_Delay(5);

    // Conmutar la interfaz a 4 bits enviando el nibble 0x20
    SendNibble(0x20);
    HAL_Delay(10);

    // --- A PARTIR DE AQUÍ SE ENVIAN PAQUETES DOBLES (4 BITS) ---
    ST7920_SendCmd(0x20); // Function Set: 4-bit, basic instruction set
    HAL_Delay(2);

    ST7920_SendCmd(0x0C); // Display ON, Cursor OFF, Blink OFF
    HAL_Delay(2);

    ST7920_SendCmd(0x01); // Display Clear (Limpia los bloques negros)
    HAL_Delay(20);

    ST7920_SendCmd(0x06); // Entry Mode: Increment Cursor
    HAL_Delay(2);
}

void ST7920_SendString(int row, int col, char* str) {
    uint8_t addr = 0x80;

    switch (row) {
        case 0: addr = 0x80 + col; break;
        case 1: addr = 0x90 + col; break;
        case 2: addr = 0x88 + col; break;
        case 3: addr = 0x98 + col; break;
        default: addr = 0x80 + col; break;
    }

    ST7920_SendCmd(addr);

    while (*str) {
        ST7920_SendData(*str++);
    }
}

void ST7920_Clear(void) {
    if (Graphic_Check == 1) {
        ST7920_ClearBuffer();
        ST7920_Update();
    } else {
        ST7920_SendCmd(0x01);
        HAL_Delay(15);
    }
}

void ST7920_GraphicMode(int enable) {
    if (enable == 1) {
        ST7920_SendCmd(0x20);
        DelayUs(100);
        ST7920_SendCmd(0x24);
        DelayUs(100);
        ST7920_SendCmd(0x26);
        DelayUs(100);
        Graphic_Check = 1;
    } else {
        ST7920_SendCmd(0x20);
        DelayUs(100);
        Graphic_Check = 0;
    }
}

void ST7920_DrawBitmap(const unsigned char* graphic) {
    uint8_t x, y;
    for (y = 0; y < 64; y++) {
        if (y < 32) {
            for (x = 0; x < 8; x++) {
                ST7920_SendCmd(0x80 | y);
                ST7920_SendCmd(0x80 | x);
                ST7920_SendData(graphic[2 * x + 16 * y]);
                ST7920_SendData(graphic[2 * x + 1 + 16 * y]);
            }
        } else {
            for (x = 0; x < 8; x++) {
                ST7920_SendCmd(0x80 | (y - 32));
                ST7920_SendCmd(0x88 | x);
                ST7920_SendData(graphic[2 * x + 16 * y]);
                ST7920_SendData(graphic[2 * x + 1 + 16 * y]);
            }
        }
    }
}

void ST7920_Update(void) {
    ST7920_DrawBitmap(image);
}

void ST7920_ClearBuffer(void) {
    for (int i = 0; i < (128 * 64) / 8; i++) {
        image[i] = 0x00;
    }
}

void SetPixel(uint8_t x, uint8_t y) {
    if (y < numRows && x < numCols) {
        uint8_t *p = image + ((y * (numCols / 8)) + (x / 8));
        *p |= 0x80u >> (x % 8);
    }
}

void DrawLine(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1) {
    int dx = (x1 >= x0) ? x1 - x0 : x0 - x1;
    int dy = (y1 >= y0) ? y1 - y0 : y0 - y1;
    int sx = (x0 < x1) ? 1 : -1;
    int sy = (y0 < y1) ? 1 : -1;
    int err = dx - dy;

    for (;;) {
        SetPixel(x0, y0);
        if (x0 == x1 && y0 == y1) break;
        int e2 = err + err;
        if (e2 > -dy) {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dx) {
            err += dx;
            y0 += sy;
        }
    }
}

void DrawRectangle(uint16_t x, uint16_t y, uint16_t w, uint16_t h) {
    if (x >= numCols || y >= numRows) return;
    if ((x + w) >= numCols) w = numCols - x;
    if ((y + h) >= numRows) h = numRows - y;

    DrawLine(x, y, x + w, y);
    DrawLine(x, y + h, x + w, y + h);
    DrawLine(x, y, x, y + h);
    DrawLine(x + w, y, x + w, y + h);
}

void DrawFilledRectangle(uint16_t x, uint16_t y, uint16_t w, uint16_t h) {
    uint8_t i;
    if (x >= numCols || y >= numRows) return;
    if ((x + w) >= numCols) w = numCols - x;
    if ((y + h) >= numRows) h = numRows - y;

    for (i = 0; i <= h; i++) {
        DrawLine(x, y + i, x + w, y + i);
    }
}

void DrawCircle(uint8_t x0, uint8_t y0, uint8_t radius) {
    int f = 1 - (int)radius;
    int ddF_x = 1;
    int ddF_y = -2 * (int)radius;
    int x = 0;

    SetPixel(x0, y0 + radius);
    SetPixel(x0, y0 - radius);
    SetPixel(x0 + radius, y0);
    SetPixel(x0 - radius, y0);

    int y = radius;
    while (x < y) {
        if (f >= 0) {
            y--;
            ddF_y += 2;
            f += ddF_y;
        }
        x++;
        ddF_x += 2;
        f += ddF_x;
        SetPixel(x0 + x, y0 + y);
        SetPixel(x0 - x, y0 + y);
        SetPixel(x0 + x, y0 - y);
        SetPixel(x0 - x, y0 - y);
        SetPixel(x0 + y, y0 + x);
        SetPixel(x0 - y, y0 + x);
        SetPixel(x0 + y, y0 - x);
        SetPixel(x0 - y, y0 - x);
    }
}

void DrawFilledCircle(int16_t x0, int16_t y0, int16_t r) {
    int16_t f = 1 - r;
    int16_t ddF_x = 1;
    int16_t ddF_y = -2 * r;
    int16_t x = 0;
    int16_t y = r;

    SetPixel(x0, y0 + r);
    SetPixel(x0, y0 - r);
    SetPixel(x0 + r, y0);
    SetPixel(x0 - r, y0);
    DrawLine(x0 - r, y0, x0 + r, y0);

    while (x < y) {
        if (f >= 0) {
            y--;
            ddF_y += 2;
            f += ddF_y;
        }
        x++;
        ddF_x += 2;
        f += ddF_x;

        DrawLine(x0 - x, y0 + y, x0 + x, y0 + y);
        DrawLine(x0 + x, y0 - y, x0 - x, y0 - y);
        DrawLine(x0 + y, y0 + x, x0 - y, y0 + x);
        DrawLine(x0 + y, y0 - x, x0 - y, y0 - x);
    }
}

void DrawTriangle(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t x3, uint16_t y3) {
    DrawLine(x1, y1, x2, y2);
    DrawLine(x2, y2, x3, y3);
    DrawLine(x3, y3, x1, y1);
}

void DrawFilledTriangle(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t x3, uint16_t y3) {
    int16_t deltax = 0, deltay = 0, x = 0, y = 0, xinc1 = 0, xinc2 = 0,
            yinc1 = 0, yinc2 = 0, den = 0, num = 0, numadd = 0, numpixels = 0,
            curpixel = 0;

#define ABS(x)   ((x) > 0 ? (x) : -(x))

    deltax = ABS(x2 - x1);
    deltay = ABS(y2 - y1);
    x = x1;
    y = y1;

    if (x2 >= x1) { xinc1 = 1; xinc2 = 1; }
    else          { xinc1 = -1; xinc2 = -1; }

    if (y2 >= y1) { yinc1 = 1; yinc2 = 1; }
    else          { yinc1 = -1; yinc2 = -1; }

    if (deltax >= deltay) {
        xinc1 = 0;
        yinc2 = 0;
        den = deltax;
        num = deltax / 2;
        numadd = deltay;
        numpixels = deltax;
    } else {
        xinc2 = 0;
        yinc1 = 0;
        den = deltay;
        num = deltay / 2;
        numadd = deltax;
        numpixels = deltay;
    }

    for (curpixel = 0; curpixel <= numpixels; curpixel++) {
        DrawLine(x, y, x3, y3);

        num += numadd;
        if (num >= den) {
            num -= den;
            x += xinc1;
            y += yinc1;
        }
        x += xinc2;
        y += yinc2;
    }
}
