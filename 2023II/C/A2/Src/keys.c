
/*==================[ Inclusions ]============================================*/
#include "main.h"
#include "cmsis_os.h"
#include "keys.h"
#include "semphr.h"

/*=====[ Definitions of private data types ]===================================*/
const uint32_t  keys_config[] = {GPIO_PIN_7, GPIO_PIN_14, GPIO_PIN_15, GPIO_PIN_12};
const uint32_t  keys_config_port[] = {GPIOA, GPIOD, GPIOD, GPIOF};
extern SemaphoreHandle_t sem_btn[];

/*=====[Definition macros of private constants]==============================*/

#define KEY_COUNT   sizeof(keys_config)/sizeof(keys_config[0])
#define DEBOUNCE_TIME   40
#define DEBOUNCE_TIME_MS pdMS_TO_TICKS(DEBOUNCE_TIME)

/*=====[Prototypes (declarations) of private functions]======================*/

static void keys_ButtonError( uint32_t index );
static void buttonPressed( uint32_t index );
static void buttonReleased( uint32_t index );

/*=====[Definitions of private global variables]=============================*/

/*=====[Definitions of public global variables]==============================*/
t_key_data keys_data[KEY_COUNT];

/*=====[prototype of private functions]=================================*/
void task_tecla( void* taskParmPtr );

/*=====[Implementations of public functions]=================================*/
TickType_t get_diff( uint32_t index )
{
    TickType_t tiempo;
    tiempo = keys_data[index].time_diff;

    return tiempo;
}

void clear_diff( uint32_t index )
{
    keys_data[index].time_diff = KEYS_INVALID_TIME;
}

void keys_Init( void )
{
    BaseType_t res;
    uint32_t i;

    for ( i = 0 ; i < KEY_COUNT ; i++ )
    {
        keys_data[i].state          = STATE_BUTTON_UP;  // Set initial state
        keys_data[i].time_down      = KEYS_INVALID_TIME;
        keys_data[i].time_up        = KEYS_INVALID_TIME;
        keys_data[i].time_diff      = KEYS_INVALID_TIME;
    }
    // Crear tareas en freeRTOS
    res = xTaskCreate (
              task_tecla,					// Funcion de la tarea a ejecutar
              ( const char * )"task_tecla",	// Nombre de la tarea como String amigable para el usuario
              configMINIMAL_STACK_SIZE*2,	// Cantidad de stack de la tarea
              0,							// Parametros de tarea
              tskIDLE_PRIORITY+1,			// Prioridad de la tarea
              0								// Puntero a la tarea creada en el sistema
          );

    // Gestión de errores
    configASSERT( res == pdPASS );
}

// keys_ Update State Function
void keys_Update( uint32_t index )
{
    switch( keys_data[index].state )
    {
        case STATE_BUTTON_UP:
            /* CHECK TRANSITION CONDITIONS */
            if( !HAL_GPIO_ReadPin(keys_config_port[index] , keys_config[index] ) )
            {
                keys_data[index].state = STATE_BUTTON_FALLING;
            }
            break;

        case STATE_BUTTON_FALLING:
            /* ENTRY */

            /* CHECK TRANSITION CONDITIONS */
            if( !HAL_GPIO_ReadPin(keys_config_port[index] , keys_config[index] ) )
            {
                keys_data[index].state = STATE_BUTTON_DOWN;

                /* ACCION DEL EVENTO !*/
                buttonPressed( index );
            }
            else
            {
                keys_data[index].state = STATE_BUTTON_UP;
            }

            /* LEAVE */
            break;

        case STATE_BUTTON_DOWN:
            /* CHECK TRANSITION CONDITIONS */
            if( HAL_GPIO_ReadPin(keys_config_port[index] , keys_config[index] ) )
            {
                keys_data[index].state = STATE_BUTTON_RISING;
            }
            break;

        case STATE_BUTTON_RISING:
            /* ENTRY */

            /* CHECK TRANSITION CONDITIONS */

            if( HAL_GPIO_ReadPin(keys_config_port[index] , keys_config[index] ) )
            {
                keys_data[index].state = STATE_BUTTON_UP;

                /* ACCION DEL EVENTO ! */
                buttonReleased( index );
            }
            else
            {
                keys_data[index].state = STATE_BUTTON_DOWN;
            }

            /* LEAVE */
            break;

        default:
            keys_ButtonError( index );
            break;
    }
}

/*=====[Implementations of private functions]================================*/

/* accion de el evento de tecla pulsada */
static void buttonPressed( uint32_t index )
{
    TickType_t current_tick_count = xTaskGetTickCount();

    keys_data[index].time_down = current_tick_count;
}

/* accion de el evento de tecla liberada */
static void buttonReleased( uint32_t index )
{
    TickType_t current_tick_count = xTaskGetTickCount();

    keys_data[index].time_up    = current_tick_count;
    keys_data[index].time_diff  = keys_data[index].time_up - keys_data[index].time_down;

    if ( keys_data[index].time_diff  > 0 )
    {
        xSemaphoreGive( sem_btn[index] );
    }

}

static void keys_ButtonError( uint32_t index )
{
    keys_data[index].state = STATE_BUTTON_UP;
}

/*=====[Implementations of private functions]=================================*/
void task_tecla( void* taskParmPtr )
{
    uint32_t i;
    while( 1 )
    {
        for ( i = 0 ; i < KEY_COUNT ; i++ )
        {
            keys_Update( i );
        }
        vTaskDelay( DEBOUNCE_TIME_MS );
    }
}
