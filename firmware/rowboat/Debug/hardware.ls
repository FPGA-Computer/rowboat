   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  43                     ; 5 void Init_TIM2(void)
  43                     ; 6 { 
  45                     	switch	.text
  46  0000               _Init_TIM2:
  50                     ; 8 	CLK->CKDIVR = 0;
  52  0000 725f50c6      	clr	20678
  53                     ; 10   TIM2->PSCR = TIM2_PSCR;
  55  0004 3503530e      	mov	21262,#3
  56                     ; 11 	TIM2->ARRH = TIM2_ARRH;
  58  0008 359c530f      	mov	21263,#156
  59                     ; 12 	TIM2->ARRL = TIM2_ARRL;
  61  000c 35405310      	mov	21264,#64
  62                     ; 15 	TIM2->IER = TIM2_IER_UIE;
  64  0010 35015303      	mov	21251,#1
  65                     ; 18 	TIM2->CCMR2 = (0x06 <<4)|TIM2_CCMR_OCxPE;
  67  0014 35685308      	mov	21256,#104
  68                     ; 20 	TIM2->CCER1 |= TIM2_CCER1_CC2E;
  70  0018 7218530a      	bset	21258,#4
  71                     ; 22 	TIM2->CR1 = TIM2_CR1_CEN;
  73  001c 35015300      	mov	21248,#1
  74                     ; 23 }
  77  0020 81            	ret
 101                     ; 26 @far @interrupt void TIM2_Update_IRQ(void)
 101                     ; 27 {	
 103                     	switch	.text
 104  0021               f_TIM2_Update_IRQ:
 106  0021 8a            	push	cc
 107  0022 84            	pop	a
 108  0023 a4bf          	and	a,#191
 109  0025 88            	push	a
 110  0026 86            	pop	cc
 111       00000002      OFST:	set	2
 112  0027 be00          	ldw	x,c_x
 113  0029 89            	pushw	x
 114  002a 89            	pushw	x
 117                     ; 28 	TIM2->SR1 &= ~TIM2_SR1_UIF;													// Clear update IRQ
 119  002b 72115304      	bres	21252,#0
 120                     ; 30   if(!ServoStep.Table)																// turn off servo
 122  002f be00          	ldw	x,_ServoStep
 123  0031 2607          	jrne	L13
 124                     ; 32 		ServoStep.PWM = SERVO_OFF;
 126  0033 5f            	clrw	x
 127  0034 bf03          	ldw	_ServoStep+3,x
 128                     ; 33 		ServoStep.Index = 0;
 130  0036 3f02          	clr	_ServoStep+2
 132  0038 206b          	jra	L33
 133  003a               L13:
 134                     ; 37 		if(!ServoStep.Steps)															// Initialize Table ptr
 136  003a 3d07          	tnz	_ServoStep+7
 137  003c 265d          	jrne	L53
 138                     ; 39 			if(ServoStep.Table[ServoStep.Index].From == END_TABLE)
 140  003e b602          	ld	a,_ServoStep+2
 141  0040 97            	ld	xl,a
 142  0041 a605          	ld	a,#5
 143  0043 42            	mul	x,a
 144  0044 72bb0000      	addw	x,_ServoStep
 145  0048 e601          	ld	a,(1,x)
 146  004a fa            	or	a,(x)
 147  004b 2602          	jrne	L73
 148                     ; 40 				ServoStep.Index = 0;
 150  004d 3f02          	clr	_ServoStep+2
 151  004f               L73:
 152                     ; 42 			ServoStep.PWM = ServoStep.Table[ServoStep.Index].From;
 154  004f b602          	ld	a,_ServoStep+2
 155  0051 97            	ld	xl,a
 156  0052 a605          	ld	a,#5
 157  0054 42            	mul	x,a
 158  0055 92de00        	ldw	x,([_ServoStep.w],x)
 159  0058 bf03          	ldw	_ServoStep+3,x
 160                     ; 44 			ServoStep.Delta =(ServoStep.Table[ServoStep.Index].To - 
 160                     ; 45 												ServoStep.Table[ServoStep.Index].From)/
 160                     ; 46 												ServoStep.Table[ServoStep.Index].Steps;
 162  005a b602          	ld	a,_ServoStep+2
 163  005c 97            	ld	xl,a
 164  005d a605          	ld	a,#5
 165  005f 42            	mul	x,a
 166  0060 72bb0000      	addw	x,_ServoStep
 167  0064 fe            	ldw	x,(x)
 168  0065 1f01          	ldw	(OFST-1,sp),x
 170  0067 b602          	ld	a,_ServoStep+2
 171  0069 97            	ld	xl,a
 172  006a a605          	ld	a,#5
 173  006c 42            	mul	x,a
 174  006d 72bb0000      	addw	x,_ServoStep
 175  0071 ee02          	ldw	x,(2,x)
 176  0073 72f001        	subw	x,(OFST-1,sp)
 177  0076 89            	pushw	x
 178  0077 b602          	ld	a,_ServoStep+2
 179  0079 97            	ld	xl,a
 180  007a a605          	ld	a,#5
 181  007c 42            	mul	x,a
 182  007d 72bb0000      	addw	x,_ServoStep
 183  0081 e604          	ld	a,(4,x)
 184  0083 85            	popw	x
 185  0084 cd0000        	call	c_sdivx
 187  0087 bf05          	ldw	_ServoStep+5,x
 188                     ; 48 			ServoStep.Steps = ServoStep.Table[ServoStep.Index].Steps;
 190  0089 b602          	ld	a,_ServoStep+2
 191  008b 97            	ld	xl,a
 192  008c a605          	ld	a,#5
 193  008e 42            	mul	x,a
 194  008f 72bb0000      	addw	x,_ServoStep
 195  0093 e604          	ld	a,(4,x)
 196  0095 b707          	ld	_ServoStep+7,a
 197                     ; 49 			ServoStep.Index++;			
 199  0097 3c02          	inc	_ServoStep+2
 201  0099 200a          	jra	L33
 202  009b               L53:
 203                     ; 53 			ServoStep.PWM += ServoStep.Delta;
 205  009b be03          	ldw	x,_ServoStep+3
 206  009d 72bb0005      	addw	x,_ServoStep+5
 207  00a1 bf03          	ldw	_ServoStep+3,x
 208                     ; 54 			ServoStep.Steps--;
 210  00a3 3a07          	dec	_ServoStep+7
 211  00a5               L33:
 212                     ; 58 	if ((ServoStep.PWM >= SERVO_MIN) &&	(ServoStep.PWM <= SERVO_MAX))
 214  00a5 9c            	rvf
 215  00a6 be03          	ldw	x,_ServoStep+3
 216  00a8 a307d0        	cpw	x,#2000
 217  00ab 2f12          	jrslt	L34
 219  00ad 9c            	rvf
 220  00ae be03          	ldw	x,_ServoStep+3
 221  00b0 a30fa1        	cpw	x,#4001
 222  00b3 2e0a          	jrsge	L34
 223                     ; 60 		TIM2->CCR2H = ServoStep.PWM >>8;
 225  00b5 5500035313    	mov	21267,_ServoStep+3
 226                     ; 61 		TIM2->CCR2L = ServoStep.PWM;
 228  00ba 5500045314    	mov	21268,_ServoStep+4
 229  00bf               L34:
 230                     ; 63 }
 233  00bf 5b02          	addw	sp,#2
 234  00c1 85            	popw	x
 235  00c2 bf00          	ldw	c_x,x
 236  00c4 80            	iret
 335                     	xdef	_Init_TIM2
 336                     	switch	.ubsct
 337  0000               _ServoStep:
 338  0000 000000000000  	ds.b	8
 339                     	xdef	_ServoStep
 340                     	xdef	f_TIM2_Update_IRQ
 341                     	xref.b	c_x
 361                     	xref	c_sdivx
 362                     	end
