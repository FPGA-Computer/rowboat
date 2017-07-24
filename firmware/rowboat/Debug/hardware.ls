   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  43                     ; 30 void Init_TIM2(void)
  43                     ; 31 { 
  45                     	switch	.text
  46  0000               _Init_TIM2:
  50                     ; 33 	CLK->CKDIVR = 0;
  52  0000 725f50c6      	clr	20678
  53                     ; 35   TIM2->PSCR = TIM2_PSCR;
  55  0004 3503530e      	mov	21262,#3
  56                     ; 36 	TIM2->ARRH = TIM2_ARRH;
  58  0008 359c530f      	mov	21263,#156
  59                     ; 37 	TIM2->ARRL = TIM2_ARRL;
  61  000c 35405310      	mov	21264,#64
  62                     ; 40 	TIM2->IER = TIM2_IER_UIE| TIM2_IER_CC3IE;
  64  0010 35095303      	mov	21251,#9
  65                     ; 44 	TIM2->CCMR2 = (0x06 <<4)|TIM2_CCMR_OCxPE;
  67  0014 35685308      	mov	21256,#104
  68                     ; 46 	TIM2->CCER1 |= TIM2_CCER1_CC2E;
  70  0018 7218530a      	bset	21258,#4
  71                     ; 50 	TIM2->CCMR3 = /*0xf0 |*/ 0x01;
  73  001c 35015309      	mov	21257,#1
  74                     ; 53 	TIM2->CCER2 |= TIM2_CCER2_CC3E|TIM2_CCER2_CC3P;
  76  0020 c6530b        	ld	a,21259
  77  0023 aa03          	or	a,#3
  78  0025 c7530b        	ld	21259,a
  79                     ; 55 	TIM2->CR1 = TIM2_CR1_CEN;
  81  0028 35015300      	mov	21248,#1
  82                     ; 56 }
  85  002c 81            	ret
 110                     ; 59 @far @interrupt void TIM2_Update_IRQ(void)
 110                     ; 60 {	
 112                     	switch	.text
 113  002d               f_TIM2_Update_IRQ:
 115  002d 8a            	push	cc
 116  002e 84            	pop	a
 117  002f a4bf          	and	a,#191
 118  0031 88            	push	a
 119  0032 86            	pop	cc
 120       00000002      OFST:	set	2
 121  0033 be00          	ldw	x,c_x
 122  0035 89            	pushw	x
 123  0036 89            	pushw	x
 126                     ; 61 	TIM2->SR1 &= ~TIM2_SR1_UIF;													// Clear update IRQ
 128  0037 72115304      	bres	21252,#0
 129                     ; 62   IR_State.Overflow = 1;															// Keep track of overflow
 131  003b 35010007      	mov	_IR_State+7,#1
 132                     ; 64   if(!ServoStep.Table)																// turn off servo
 134  003f be0b          	ldw	x,_ServoStep
 135  0041 260b          	jrne	L13
 136                     ; 66 		ServoStep.Table = ServoStep.NextTable;
 138  0043 be0d          	ldw	x,_ServoStep+2
 139  0045 bf0b          	ldw	_ServoStep,x
 140                     ; 67 		ServoStep.PWM = SERVO_OFF;
 142  0047 5f            	clrw	x
 143  0048 bf10          	ldw	_ServoStep+5,x
 144                     ; 68 		ServoStep.Index = 0;
 146  004a 3f0f          	clr	_ServoStep+4
 148  004c 2073          	jra	L33
 149  004e               L13:
 150                     ; 72 		if(!ServoStep.Steps)															// Initialize Table ptr
 152  004e 3d14          	tnz	_ServoStep+9
 153  0050 2665          	jrne	L53
 154                     ; 74 			if(ServoStep.Table[ServoStep.Index].From == END_TABLE)
 156  0052 b60f          	ld	a,_ServoStep+4
 157  0054 97            	ld	xl,a
 158  0055 a605          	ld	a,#5
 159  0057 42            	mul	x,a
 160  0058 72bb000b      	addw	x,_ServoStep
 161  005c e601          	ld	a,(1,x)
 162  005e fa            	or	a,(x)
 163  005f 260a          	jrne	L73
 164                     ; 76 				ServoStep.Index = 0;
 166  0061 3f0f          	clr	_ServoStep+4
 167                     ; 77 				ServoStep.Table = ServoStep.NextTable;
 169  0063 be0d          	ldw	x,_ServoStep+2
 170  0065 bf0b          	ldw	_ServoStep,x
 171                     ; 79 			  if(!ServoStep.NextTable)
 173  0067 be0d          	ldw	x,_ServoStep+2
 174  0069 2770          	jreq	L01
 175                     ; 80 				  return;
 177  006b               L73:
 178                     ; 83 			ServoStep.PWM = ServoStep.Table[ServoStep.Index].From;
 180  006b b60f          	ld	a,_ServoStep+4
 181  006d 97            	ld	xl,a
 182  006e a605          	ld	a,#5
 183  0070 42            	mul	x,a
 184  0071 92de0b        	ldw	x,([_ServoStep.w],x)
 185  0074 bf10          	ldw	_ServoStep+5,x
 186                     ; 85 			ServoStep.Delta =(ServoStep.Table[ServoStep.Index].To - 
 186                     ; 86 												ServoStep.Table[ServoStep.Index].From)/
 186                     ; 87 												ServoStep.Table[ServoStep.Index].Steps;
 188  0076 b60f          	ld	a,_ServoStep+4
 189  0078 97            	ld	xl,a
 190  0079 a605          	ld	a,#5
 191  007b 42            	mul	x,a
 192  007c 72bb000b      	addw	x,_ServoStep
 193  0080 fe            	ldw	x,(x)
 194  0081 1f01          	ldw	(OFST-1,sp),x
 196  0083 b60f          	ld	a,_ServoStep+4
 197  0085 97            	ld	xl,a
 198  0086 a605          	ld	a,#5
 199  0088 42            	mul	x,a
 200  0089 72bb000b      	addw	x,_ServoStep
 201  008d ee02          	ldw	x,(2,x)
 202  008f 72f001        	subw	x,(OFST-1,sp)
 203  0092 89            	pushw	x
 204  0093 b60f          	ld	a,_ServoStep+4
 205  0095 97            	ld	xl,a
 206  0096 a605          	ld	a,#5
 207  0098 42            	mul	x,a
 208  0099 72bb000b      	addw	x,_ServoStep
 209  009d e604          	ld	a,(4,x)
 210  009f 85            	popw	x
 211  00a0 cd0000        	call	c_sdivx
 213  00a3 bf12          	ldw	_ServoStep+7,x
 214                     ; 89 			ServoStep.Steps = ServoStep.Table[ServoStep.Index].Steps;
 216  00a5 b60f          	ld	a,_ServoStep+4
 217  00a7 97            	ld	xl,a
 218  00a8 a605          	ld	a,#5
 219  00aa 42            	mul	x,a
 220  00ab 72bb000b      	addw	x,_ServoStep
 221  00af e604          	ld	a,(4,x)
 222  00b1 b714          	ld	_ServoStep+9,a
 223                     ; 90 			ServoStep.Index++;			
 225  00b3 3c0f          	inc	_ServoStep+4
 227  00b5 200a          	jra	L33
 228  00b7               L53:
 229                     ; 94 			ServoStep.PWM += ServoStep.Delta;
 231  00b7 be10          	ldw	x,_ServoStep+5
 232  00b9 72bb0012      	addw	x,_ServoStep+7
 233  00bd bf10          	ldw	_ServoStep+5,x
 234                     ; 95 			ServoStep.Steps--;
 236  00bf 3a14          	dec	_ServoStep+9
 237  00c1               L33:
 238                     ; 99 	if ((ServoStep.PWM >= SERVO_MIN) &&	(ServoStep.PWM <= SERVO_MAX))
 240  00c1 9c            	rvf
 241  00c2 be10          	ldw	x,_ServoStep+5
 242  00c4 a307d0        	cpw	x,#2000
 243  00c7 2f12          	jrslt	L54
 245  00c9 9c            	rvf
 246  00ca be10          	ldw	x,_ServoStep+5
 247  00cc a30fa1        	cpw	x,#4001
 248  00cf 2e0a          	jrsge	L54
 249                     ; 101 		TIM2->CCR2H = ServoStep.PWM >>8;
 251  00d1 5500105313    	mov	21267,_ServoStep+5
 252                     ; 102 		TIM2->CCR2L = ServoStep.PWM;
 254  00d6 5500115314    	mov	21268,_ServoStep+6
 255  00db               L54:
 256                     ; 104 }
 257  00db               L01:
 260  00db 5b02          	addw	sp,#2
 261  00dd 85            	popw	x
 262  00de bf00          	ldw	c_x,x
 263  00e0 80            	iret
 306                     ; 107 @far @interrupt void TIM2_Capture_IRQ(void)
 306                     ; 108 {
 307                     	switch	.text
 308  00e1               f_TIM2_Capture_IRQ:
 310       00000004      OFST:	set	4
 311  00e1 be00          	ldw	x,c_x
 312  00e3 89            	pushw	x
 313  00e4 be02          	ldw	x,c_lreg+2
 314  00e6 89            	pushw	x
 315  00e7 be00          	ldw	x,c_lreg
 316  00e9 89            	pushw	x
 317  00ea 5204          	subw	sp,#4
 320                     ; 111 	TIM2->SR1 &= ~TIM2_SR1_CC3IF;										// Clear Capture IRQ
 322  00ec 72175304      	bres	21252,#3
 323                     ; 112 	IC3 = (TIM2->CCR3H <<8)|TIM2->CCR3L;
 325  00f0 c65315        	ld	a,21269
 326  00f3 5f            	clrw	x
 327  00f4 97            	ld	xl,a
 328  00f5 c65316        	ld	a,21270
 329  00f8 02            	rlwa	x,a
 330  00f9 1f01          	ldw	(OFST-3,sp),x
 332                     ; 114 	if(IR_State.Overflow)
 334  00fb 3d07          	tnz	_IR_State+7
 335  00fd 270e          	jreq	L17
 336                     ; 115 	  Delta = IC3 + (TIM2_RELOAD - IR_State.Capture);
 338  00ff ae9c40        	ldw	x,#40000
 339  0102 72b00009      	subw	x,_IR_State+9
 340  0106 72fb01        	addw	x,(OFST-3,sp)
 341  0109 1f03          	ldw	(OFST-1,sp),x
 344  010b 2008          	jra	L37
 345  010d               L17:
 346                     ; 117 		Delta = IC3 - IR_State.Capture;	
 348  010d 1e01          	ldw	x,(OFST-3,sp)
 349  010f 72b00009      	subw	x,_IR_State+9
 350  0113 1f03          	ldw	(OFST-1,sp),x
 352  0115               L37:
 353                     ; 119 	IR_State.Capture = IC3;
 355  0115 1e01          	ldw	x,(OFST-3,sp)
 356  0117 bf09          	ldw	_IR_State+9,x
 357                     ; 120 	IR_State.Overflow = 0;
 359  0119 3f07          	clr	_IR_State+7
 360                     ; 122 	if(!(TIM2->CCER2 & TIM2_CCER2_CC3P))						// Rising edge
 362  011b c6530b        	ld	a,21259
 363  011e a502          	bcp	a,#2
 364  0120 2704          	jreq	L61
 365  0122 acc401c4      	jpf	L57
 366  0126               L61:
 367                     ; 124 		TIM2->CCER2 |= TIM2_CCER2_CC3P;								// next capture to falling edge
 369  0126 7212530b      	bset	21259,#1
 370                     ; 127 		if(IR_PULSE(IR_NEC_PRE,Delta))
 372  012a 9c            	rvf
 373  012b 1e03          	ldw	x,(OFST-1,sp)
 374  012d cd0000        	call	c_uitof
 376  0130 ae001c        	ldw	x,#L501
 377  0133 cd0000        	call	c_fcmp
 379  0136 2f16          	jrslt	L77
 381  0138 9c            	rvf
 382  0139 1e03          	ldw	x,(OFST-1,sp)
 383  013b cd0000        	call	c_uitof
 385  013e ae0018        	ldw	x,#L511
 386  0141 cd0000        	call	c_fcmp
 388  0144 2c08          	jrsgt	L77
 389                     ; 128 			IR_State.Bit = IR_Lead;
 391  0146 35ff0005      	mov	_IR_State+5,#255
 393  014a ac490249      	jpf	L551
 394  014e               L77:
 395                     ; 131 		else if(IR_PULSE(IR_NEC_BIT,Delta))
 397  014e 9c            	rvf
 398  014f 1e03          	ldw	x,(OFST-1,sp)
 399  0151 cd0000        	call	c_uitof
 401  0154 ae0014        	ldw	x,#L131
 402  0157 cd0000        	call	c_fcmp
 404  015a 2f60          	jrslt	L321
 406  015c 9c            	rvf
 407  015d 1e03          	ldw	x,(OFST-1,sp)
 408  015f cd0000        	call	c_uitof
 410  0162 ae0010        	ldw	x,#L141
 411  0165 cd0000        	call	c_fcmp
 413  0168 2c52          	jrsgt	L321
 414                     ; 133 			if(IR_State.Bit && !(IR_State.Bit%8))				// Save every 8 bits
 416  016a 3d05          	tnz	_IR_State+5
 417  016c 2604          	jrne	L02
 418  016e ac490249      	jpf	L551
 419  0172               L02:
 421  0172 5f            	clrw	x
 422  0173 b605          	ld	a,_IR_State+5
 423  0175 2a01          	jrpl	L41
 424  0177 53            	cplw	x
 425  0178               L41:
 426  0178 97            	ld	xl,a
 427  0179 a608          	ld	a,#8
 428  017b cd0000        	call	c_smodx
 430  017e a30000        	cpw	x,#0
 431  0181 2704          	jreq	L22
 432  0183 ac490249      	jpf	L551
 433  0187               L22:
 434                     ; 135 				IR_State.Byte[IR_State.Word++]=IR_State.Scratch; 
 436  0187 b606          	ld	a,_IR_State+6
 437  0189 97            	ld	xl,a
 438  018a 3c06          	inc	_IR_State+6
 439  018c 9f            	ld	a,xl
 440  018d 5f            	clrw	x
 441  018e 97            	ld	xl,a
 442  018f b604          	ld	a,_IR_State+4
 443  0191 e700          	ld	(_IR_State,x),a
 444                     ; 137 				if(IR_State.Word==4)
 446  0193 b606          	ld	a,_IR_State+6
 447  0195 a104          	cp	a,#4
 448  0197 2704          	jreq	L42
 449  0199 ac490249      	jpf	L551
 450  019d               L42:
 451                     ; 140 					if((IR_State.Byte[IR_ADDRH]== IR_ADDRESS_H) && 
 451                     ; 141 						 (IR_State.Byte[IR_ADDRL]== IR_ADDRESS_L) &&
 451                     ; 142 						 (IR_State.Byte[IR_CMD] == (uint8_t)(~IR_State.Byte[IR_CMD_COMP])))
 453  019d b600          	ld	a,_IR_State
 454  019f a186          	cp	a,#134
 455  01a1 2611          	jrne	L151
 457  01a3 b601          	ld	a,_IR_State+1
 458  01a5 a105          	cp	a,#5
 459  01a7 260b          	jrne	L151
 461  01a9 b603          	ld	a,_IR_State+3
 462  01ab 43            	cpl	a
 463  01ac b102          	cp	a,_IR_State+2
 464  01ae 2604          	jrne	L151
 465                     ; 144 							IR_State.Ready = 1;
 467  01b0 35010008      	mov	_IR_State+8,#1
 468  01b4               L151:
 469                     ; 148 					IR_State.Bit = IR_Idle;						
 471  01b4 35fd0005      	mov	_IR_State+5,#253
 472  01b8 ac490249      	jpf	L551
 473  01bc               L321:
 474                     ; 153 			IR_State.Bit = IR_Idle;
 476  01bc 35fd0005      	mov	_IR_State+5,#253
 477  01c0 ac490249      	jpf	L551
 478  01c4               L57:
 479                     ; 157 		TIM2->CCER2 &=~TIM2_CCER2_CC3P;								// next capture to rising edge
 481  01c4 7213530b      	bres	21259,#1
 482                     ; 159 		if(IR_State.Bit == IR_Idle)	
 484  01c8 b605          	ld	a,_IR_State+5
 485  01ca a1fd          	cp	a,#253
 486  01cc 2606          	jrne	L751
 487                     ; 160 			IR_State.Bit = IR_Start;						
 489  01ce 35fe0005      	mov	_IR_State+5,#254
 491  01d2 2075          	jpf	L551
 492  01d4               L751:
 493                     ; 163 		else if(IR_PULSE(IR_NEC_START,Delta)&&
 493                     ; 164 			 (IR_State.Bit == IR_Lead))
 495  01d4 9c            	rvf
 496  01d5 1e03          	ldw	x,(OFST-1,sp)
 497  01d7 cd0000        	call	c_uitof
 499  01da ae000c        	ldw	x,#L171
 500  01dd cd0000        	call	c_fcmp
 502  01e0 2f1a          	jrslt	L361
 504  01e2 9c            	rvf
 505  01e3 1e03          	ldw	x,(OFST-1,sp)
 506  01e5 cd0000        	call	c_uitof
 508  01e8 ae0008        	ldw	x,#L102
 509  01eb cd0000        	call	c_fcmp
 511  01ee 2c0c          	jrsgt	L361
 513  01f0 b605          	ld	a,_IR_State+5
 514  01f2 a1ff          	cp	a,#255
 515  01f4 2606          	jrne	L361
 516                     ; 166 			IR_State.Bit = IR_Byte0_0;
 518  01f6 3f05          	clr	_IR_State+5
 519                     ; 167 			IR_State.Word = 0;
 521  01f8 3f06          	clr	_IR_State+6
 523  01fa 204d          	jra	L551
 524  01fc               L361:
 525                     ; 170 		else if(IR_PULSE(IR_NEC_BIT0,Delta))
 527  01fc 9c            	rvf
 528  01fd 1e03          	ldw	x,(OFST-1,sp)
 529  01ff cd0000        	call	c_uitof
 531  0202 ae0014        	ldw	x,#L131
 532  0205 cd0000        	call	c_fcmp
 534  0208 2f14          	jrslt	L702
 536  020a 9c            	rvf
 537  020b 1e03          	ldw	x,(OFST-1,sp)
 538  020d cd0000        	call	c_uitof
 540  0210 ae0010        	ldw	x,#L141
 541  0213 cd0000        	call	c_fcmp
 543  0216 2c06          	jrsgt	L702
 544                     ; 172 			IR_State.Scratch = IR_State.Scratch>>1;			
 546  0218 3404          	srl	_IR_State+4
 547                     ; 173 			IR_State.Bit++;			
 549  021a 3c05          	inc	_IR_State+5
 551  021c 202b          	jra	L551
 552  021e               L702:
 553                     ; 176 		else if(IR_PULSE(IR_NEC_BIT1,Delta))
 555  021e 9c            	rvf
 556  021f 1e03          	ldw	x,(OFST-1,sp)
 557  0221 cd0000        	call	c_uitof
 559  0224 ae0004        	ldw	x,#L122
 560  0227 cd0000        	call	c_fcmp
 562  022a 2f19          	jrslt	L312
 564  022c 9c            	rvf
 565  022d 1e03          	ldw	x,(OFST-1,sp)
 566  022f cd0000        	call	c_uitof
 568  0232 ae0000        	ldw	x,#L132
 569  0235 cd0000        	call	c_fcmp
 571  0238 2c0b          	jrsgt	L312
 572                     ; 178 			IR_State.Scratch = (IR_State.Scratch>>1)|0x80;			
 574  023a b604          	ld	a,_IR_State+4
 575  023c 44            	srl	a
 576  023d aa80          	or	a,#128
 577  023f b704          	ld	_IR_State+4,a
 578                     ; 179 			IR_State.Bit++;					
 580  0241 3c05          	inc	_IR_State+5
 582  0243 2004          	jra	L551
 583  0245               L312:
 584                     ; 182 			IR_State.Bit = IR_Idle;		
 586  0245 35fd0005      	mov	_IR_State+5,#253
 587  0249               L551:
 588                     ; 184 }
 591  0249 5b04          	addw	sp,#4
 592  024b 85            	popw	x
 593  024c bf00          	ldw	c_lreg,x
 594  024e 85            	popw	x
 595  024f bf02          	ldw	c_lreg+2,x
 596  0251 85            	popw	x
 597  0252 bf00          	ldw	c_x,x
 598  0254 80            	iret
 780                     	switch	.ubsct
 781  0000               _IR_State:
 782  0000 000000000000  	ds.b	11
 783                     	xdef	_IR_State
 784                     	xdef	_Init_TIM2
 785  000b               _ServoStep:
 786  000b 000000000000  	ds.b	10
 787                     	xdef	_ServoStep
 788                     	xdef	f_TIM2_Capture_IRQ
 789                     	xdef	f_TIM2_Update_IRQ
 790                     .const:	section	.text
 791  0000               L132:
 792  0000 457d2000      	dc.w	17789,8192
 793  0004               L122:
 794  0004 4528c000      	dc.w	17704,-16384
 795  0008               L102:
 796  0008 4628c000      	dc.w	17960,-16384
 797  000c               L171:
 798  000c 45e10000      	dc.w	17889,0
 799  0010               L141:
 800  0010 44a8c000      	dc.w	17576,-16384
 801  0014               L131:
 802  0014 44610000      	dc.w	17505,0
 803  0018               L511:
 804  0018 46a8c000      	dc.w	18088,-16384
 805  001c               L501:
 806  001c 46610000      	dc.w	18017,0
 807                     	xref.b	c_lreg
 808                     	xref.b	c_x
 828                     	xref	c_smodx
 829                     	xref	c_fcmp
 830                     	xref	c_uitof
 831                     	xref	c_sdivx
 832                     	end
