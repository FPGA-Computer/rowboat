/*
 * hardware.c
 *
 * Created: July-23-17, 12:00:24 AM
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
#include "ir remote.h"

ServoStep__t ServoStep;
IR_Data IR_State;

void Init_TIM2(void)
{ 
	// Clk = 16MHz
	CLK->CKDIVR = 0;

  TIM2->PSCR = TIM2_PSCR;
	TIM2->ARRH = TIM2_ARRH;
	TIM2->ARRL = TIM2_ARRL;
	
	// Update interrupt, Capture 3
	TIM2->IER = TIM2_IER_UIE| TIM2_IER_CC3IE;
	
	// -- Servo -----
	// Ch2: PWM mode 1, preload enable
	TIM2->CCMR2 = (0x06 <<4)|TIM2_CCMR_OCxPE;
	// Capture pin output enable
	TIM2->CCER1 |= TIM2_CCER1_CC2E;
	
	// -- IR Remote ----
	// Ch3: IC3f = f/32, N=8; capture input 3
	TIM2->CCMR3 = /*0xf0 |*/ 0x01;
	
	// Input capture: enable, falling edge
	TIM2->CCER2 |= TIM2_CCER2_CC3E|TIM2_CCER2_CC3P;
	// TIM2 enable
	TIM2->CR1 = TIM2_CR1_CEN;
}

// manages Servo table
@far @interrupt void TIM2_Update_IRQ(void)
{	
	TIM2->SR1 &= ~TIM2_SR1_UIF;													// Clear update IRQ
  IR_State.Overflow = 1;															// Keep track of overflow

  if(!ServoStep.Table)																// turn off servo
	{
		ServoStep.Table = ServoStep.NextTable;
		ServoStep.PWM = SERVO_OFF;
		ServoStep.Index = 0;
	}
	else
	{	
		if(!ServoStep.Steps)															// Initialize Table ptr
		{
			if(ServoStep.Table[ServoStep.Index].From == END_TABLE)
			{
				ServoStep.Index = 0;
				ServoStep.Table = ServoStep.NextTable;
				
			  if(!ServoStep.NextTable)
				  return;
			}
		
			ServoStep.PWM = ServoStep.Table[ServoStep.Index].From;
			
			ServoStep.Delta =(ServoStep.Table[ServoStep.Index].To - 
												ServoStep.Table[ServoStep.Index].From)/
												ServoStep.Table[ServoStep.Index].Steps;
												
			ServoStep.Steps = ServoStep.Table[ServoStep.Index].Steps;
			ServoStep.Index++;			
		}
		else
		{
			ServoStep.PWM += ServoStep.Delta;
			ServoStep.Steps--;
		}
	}
	
	if ((ServoStep.PWM >= SERVO_MIN) &&	(ServoStep.PWM <= SERVO_MAX))
	{ // Set PWM
		TIM2->CCR2H = ServoStep.PWM >>8;
		TIM2->CCR2L = ServoStep.PWM;
	}
}

// IR remote capture for NEC2 protocol
@far @interrupt void TIM2_Capture_IRQ(void)
{
	uint16_t IC3, Delta;
	
	TIM2->SR1 &= ~TIM2_SR1_CC3IF;										// Clear Capture IRQ
	IC3 = (TIM2->CCR3H <<8)|TIM2->CCR3L;

	if(IR_State.Overflow)
	  Delta = IC3 + (TIM2_RELOAD - IR_State.Capture);
	else
		Delta = IC3 - IR_State.Capture;	

	IR_State.Capture = IC3;
	IR_State.Overflow = 0;
	
	if(!(TIM2->CCER2 & TIM2_CCER2_CC3P))						// Rising edge
	{
		TIM2->CCER2 |= TIM2_CCER2_CC3P;								// next capture to falling edge
		
		// 9ms 
		if(IR_PULSE(IR_NEC_PRE,Delta))
			IR_State.Bit = IR_Lead;
		
		// 562.5us
		else if(IR_PULSE(IR_NEC_BIT,Delta))
		{			
			if(IR_State.Bit && !(IR_State.Bit%8))				// Save every 8 bits
			{
				IR_State.Byte[IR_State.Word++]=IR_State.Scratch; 
				
				if(IR_State.Word==4)
				{
					// Matches NEC2 16-bit Address, Command: Byte 2 = complement of byte 3
					if((IR_State.Byte[IR_ADDRH]== IR_ADDRESS_H) && 
						 (IR_State.Byte[IR_ADDRL]== IR_ADDRESS_L) &&
						 (IR_State.Byte[IR_CMD] == (uint8_t)(~IR_State.Byte[IR_CMD_COMP])))
						{
							IR_State.Ready = 1;
							// raw data in IR_State.Byte[0..2]						
						}							
					
					IR_State.Bit = IR_Idle;						
				}						
			}					
		}
		else // garbage
			IR_State.Bit = IR_Idle;
	}
	else																						// Falling edge
	{
		TIM2->CCER2 &=~TIM2_CCER2_CC3P;								// next capture to rising edge

		if(IR_State.Bit == IR_Idle)	
			IR_State.Bit = IR_Start;						

		// 4.5ms space
		else if(IR_PULSE(IR_NEC_START,Delta)&&
			 (IR_State.Bit == IR_Lead))
		{		
			IR_State.Bit = IR_Byte0_0;
			IR_State.Word = 0;
		}
		// 562.5us pulse -> '0'
		else if(IR_PULSE(IR_NEC_BIT0,Delta))
		{
			IR_State.Scratch = IR_State.Scratch>>1;			
			IR_State.Bit++;			
		}
		// 1.6875ms space -> '1'
		else if(IR_PULSE(IR_NEC_BIT1,Delta))
		{
			IR_State.Scratch = (IR_State.Scratch>>1)|0x80;			
			IR_State.Bit++;					
		}				
		else // garbage
			IR_State.Bit = IR_Idle;		
	}
}

