/*
 * main.c
 *
 * Created: July-22-17, 10:34:33 PM
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

#include "hardware.h"
#include "IR Remote.h"

const ServoTable_t Neutral[]=
{ { TIM2_SERVO_SCALE(0),TIM2_SERVO_SCALE(0),1 },
	{ 0,0,0}
};

const uint8_t LED_Tbl[] =
{
 ~(LED_SEG_A|LED_SEG_E|LED_SEG_F|LED_SEG_G),	// LED_FORWARD
 ~(LED_SEG_D|LED_SEG_E|LED_SEG_F),						// LED_LEFT
 ~(LED_SEG_E|LED_SEG_G),
 ~0
};

enum LED_ROM { LED_FORWARD, LED_LEFT, LED_RIGHT, LED_OFF  };

const ServoTable_t Forward_Tbl[]=
{
	{ TIM2_SERVO_SCALE(0),TIM2_SERVO_SCALE(90),SERVO_SLOW},
	{ TIM2_SERVO_SCALE(90),TIM2_SERVO_SCALE(0),SERVO_FAST},
	{ TIM2_SERVO_SCALE(0),TIM2_SERVO_SCALE(0),SERVO_WAIT},	
	{ TIM2_SERVO_SCALE(0),TIM2_SERVO_SCALE(-90),SERVO_SLOW},
	{ TIM2_SERVO_SCALE(-90),TIM2_SERVO_SCALE(0),SERVO_FAST},
	{ TIM2_SERVO_SCALE(0),TIM2_SERVO_SCALE(0),SERVO_WAIT},	
	{ END_TABLE,END_TABLE,0},
};


const ServoTable_t Left_Tbl[]=
{
	{ TIM2_SERVO_SCALE(0),TIM2_SERVO_SCALE(-45),SERVO_ROW},
	{ TIM2_SERVO_SCALE(-45),TIM2_SERVO_SCALE(-45),SERVO_LONGWAIT},	
	{ TIM2_SERVO_SCALE(-45),TIM2_SERVO_SCALE(-90),SERVO_ROW},	
	{ TIM2_SERVO_SCALE(-90),TIM2_SERVO_SCALE(0),SERVO_ROW2},
	{ END_TABLE,END_TABLE,0},
};

const ServoTable_t Right_Tbl[]=
{
	{ TIM2_SERVO_SCALE(0),TIM2_SERVO_SCALE(45),SERVO_ROW},
	{ TIM2_SERVO_SCALE(45),TIM2_SERVO_SCALE(45),SERVO_LONGWAIT},	
	{ TIM2_SERVO_SCALE(45),TIM2_SERVO_SCALE(90),SERVO_ROW},	
	{ TIM2_SERVO_SCALE(90),TIM2_SERVO_SCALE(0),SERVO_ROW2},
	{ END_TABLE,END_TABLE,0},
};

void main(void)
{
	// LED_PORT: output, push/pull
	LED_PORT->DDR = LED_MASK;
	LED_PORT->CR1 = LED_MASK;
	LED_PORT->ODR = LED_Tbl[LED_OFF];
						
	Init_TIM2();
	// Turn on interrupts
	rim();
	
	while (1)
	{
		if(IR_State.Ready)
		{
			// decode IR command
			switch(IR_State.Byte[IR_CMD])
			{
			  case IR_Right:
					ServoStep.NextTable = Right_Tbl;
					LED_PORT->ODR = LED_Tbl[LED_RIGHT]; 
					break;
				case IR_Left:
					ServoStep.NextTable = Left_Tbl;
					LED_PORT->ODR = LED_Tbl[LED_LEFT]; 
					break;
				case IR_Up:
					ServoStep.NextTable = Forward_Tbl;
					LED_PORT->ODR = LED_Tbl[LED_FORWARD];
					break;
				case IR_Down:
				case IR_Select:
					ServoStep.NextTable = NULL;
					LED_PORT->ODR = LED_Tbl[LED_OFF];
				  break;
			}
			
			IR_State.Ready = 0;
		}
	}
}
