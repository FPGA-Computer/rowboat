/*
 * IR Remote.h
 *
 * Created: June-18-16, 6:05:57 PM
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

#ifndef _IR_REMOTE_H_
#define _IR_REMOTE_H_

#include "hardware.h"

typedef struct 
{
	uint8_t		Byte[4];
	uint8_t		Scratch;
	int8_t		Bit;
	uint8_t		Word;
	uint8_t		Overflow;
	volatile uint8_t Ready;
	uint16_t	Capture;
} IR_Data;

extern IR_Data IR_State;

enum IR_Bit
{
	IR_Idle=-3, IR_Start=-2, IR_Lead=-1, 
	IR_Byte0_0 = 0
};

// in ns
#define TIM2_RES				500
// 9ms
#define IR_NEC_PRE			(9000000UL/TIM2_RES)
// 4.5ms space
#define IR_NEC_START		(4500000UL/TIM2_RES)
// 562.5us pulse and space for '0'
#define IR_NEC_BIT			(562500UL/TIM2_RES)
// 562.5us pulse and space for '0'
#define IR_NEC_BIT0			(562500UL/TIM2_RES)
// 1.6875ms space for '1'
#define IR_NEC_BIT1			(1687500UL/TIM2_RES)

#define IR_PULSE_TOL		0.2

#define IR_PULSE_MIN(X)	((X)*(1-IR_PULSE_TOL))
#define IR_PULSE_MAX(X)	((X)*(1+IR_PULSE_TOL))

#define IR_PULSE(X,Y)		(((Y)>=IR_PULSE_MIN(X))&&((Y)<=IR_PULSE_MAX(X)))

// NEC2 protocol
#define NEC2_IR 1

// Raw IR packet ordering
enum IR_RAW { IR_ADDRH, IR_ADDRL, IR_CMD, IR_CMD_COMP };

// TV Device address for Insignia TV
#define IR_ADDRESS_H		0x86
#define IR_ADDRESS_L		0x05

enum IR_Cmd { IR_Right = 21, IR_Left = 22, IR_Up = 66, IR_Down = 67, IR_Select = 24 };

#endif
