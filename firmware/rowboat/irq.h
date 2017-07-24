/*
 * irq.h
 *
 * Created: July-22-17, 10:51:46 PM
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
 

@far @interrupt void TIM2_Update_IRQ(void);
@far @interrupt void TIM2_Capture_IRQ(void);

#define IRQ13 TIM2_Update_IRQ
#define IRQ14	TIM2_Capture_IRQ
