/*
 * hardware.h
 *
 * Created: 22/12/2016 6:03:25 AM
 *  Author: K. C. Lee
 * Copyright (c) 2016 by K. C. Lee
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.

 If not, see http://www.gnu.org/licenses/gpl-3.0.en.html 
 */ 

#ifndef HARDWARE_H_
#define HARDWARE_H_

#ifndef __CSMC__
#define __CSMC__
#endif
#define STM8S003

#include "stm8s.h"
#include <stdio.h>

// STM8S003F3P6
enum _PA { PA1=0x02, PA2=0x04, PA3=0x08 };
enum _PB { PB4=0x10, PB5=0x20 };
enum _PC { PC3=0x08, PC4=0x10, PC5=0x20, PC6=0x40, PC7=0x80 };
enum _PD { PD1=0x02, PD2=0x04, PD3=0x08, PD4=0x10, PD5=0x20, PD6=0x40 };

#include "irq.h"

// 16MHz/2^3 -> 500ns resolution
#define TIM2_PSCR								0x03
#define TIM2_CLK								(HSI_VALUE/2UL^TIM2_PSCR)

// reload for 20ms
#define TIM2_RELOAD							0x9c40

#define TIM2_ARRH								(TIM2_RELOAD>>8)
#define TIM2_ARRL								(TIM2_RELOAD&0xff)

// 1.5ms + 0.5ms* X/90
#define SERVO_NEUTRAL						3000
#define SERVO_MIN								2000
#define SERVO_MAX								4000

#define TIM2_SERVO_SCALE(X)			((X)*100/9+SERVO_NEUTRAL)
#define SERVO_OFF								0

#define END_TABLE								0

#define SERVO_FAST							1
#define SERVO_SLOW							40
#define SERVO_WAIT							5

#define SERVO_ROW								15
#define SERVO_ROW2							(SERVO_ROW*2)
#define SERVO_LONGWAIT					20

typedef struct
{
	int16_t From;
	int16_t To;
	int8_t  Steps;
} ServoTable_t;

typedef struct
{
	volatile ServoTable_t *Table;					// Current table
	volatile ServoTable_t *NextTable;			// Next table	
	uint8_t Index;												// Current table index
  int16_t PWM;													// Current PWM value
	int16_t Delta;												// Step Delta
  uint8_t Steps;												// Steps Remaining
} ServoStep__t;

// Servo TIM2 CH2
#define SERVO_PORT							GPIOD
#define SERVO_PIN								PD3

#define IR_PORT									GPIOA
#define IR_PIN									PA3

#define LED_PORT								GPIOC
#define LED_MASK								(PC7|PC6|PC5|PC4|PC3)
#define LED_SEG_G								PC7
#define LED_SEG_F								PC6
#define LED_SEG_E								PC5
#define LED_SEG_D								PC4
#define LED_SEG_A								PC3

// uart
#define UART_BAUD								115200UL
#define UART_BRR_DIV						((int)(HSI_VALUE/UART_BAUD+0.5))
#define UART_BRR1								((UART_BRR_DIV & 0x0ff0)>>4)
#define UART_BRR2								(((UART_BRR_DIV & 0xf000)>>8)|(UART_BRR_DIV & 0x0f))

#define Poll_Serial()						(UART1->SR & UART1_SR_RXNE)
#define Get_Char()							(UART1->DR)

extern ServoStep__t ServoStep;

void Init_TIM2(void);

#endif
