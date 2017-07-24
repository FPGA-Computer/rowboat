   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.5 - 29 Dec 2015
   3                     ; Generator (Limited) V4.4.4 - 27 Jan 2016
  15                     .const:	section	.text
  16  0000               _Neutral:
  17  0000 0bb8          	dc.w	3000
  18  0002 0bb8          	dc.w	3000
  19  0004 01            	dc.b	1
  20  0005 0000          	dc.w	0
  21  0007 0000          	dc.w	0
  22  0009 00            	dc.b	0
  23  000a               _LED_Tbl:
  24  000a 17            	dc.b	23
  25  000b 8f            	dc.b	143
  26  000c 5f            	dc.b	95
  27  000d ff            	dc.b	255
  28  000e               _Forward_Tbl:
  29  000e 0bb8          	dc.w	3000
  30  0010 0fa0          	dc.w	4000
  31  0012 28            	dc.b	40
  32  0013 0fa0          	dc.w	4000
  33  0015 0bb8          	dc.w	3000
  34  0017 01            	dc.b	1
  35  0018 0bb8          	dc.w	3000
  36  001a 0bb8          	dc.w	3000
  37  001c 05            	dc.b	5
  38  001d 0bb8          	dc.w	3000
  39  001f 07d0          	dc.w	2000
  40  0021 28            	dc.b	40
  41  0022 07d0          	dc.w	2000
  42  0024 0bb8          	dc.w	3000
  43  0026 01            	dc.b	1
  44  0027 0bb8          	dc.w	3000
  45  0029 0bb8          	dc.w	3000
  46  002b 05            	dc.b	5
  47  002c 0000          	dc.w	0
  48  002e 0000          	dc.w	0
  49  0030 00            	dc.b	0
  50  0031               _Left_Tbl:
  51  0031 0bb8          	dc.w	3000
  52  0033 09c4          	dc.w	2500
  53  0035 0f            	dc.b	15
  54  0036 09c4          	dc.w	2500
  55  0038 09c4          	dc.w	2500
  56  003a 14            	dc.b	20
  57  003b 09c4          	dc.w	2500
  58  003d 07d0          	dc.w	2000
  59  003f 0f            	dc.b	15
  60  0040 07d0          	dc.w	2000
  61  0042 0bb8          	dc.w	3000
  62  0044 1e            	dc.b	30
  63  0045 0000          	dc.w	0
  64  0047 0000          	dc.w	0
  65  0049 00            	dc.b	0
  66  004a               _Right_Tbl:
  67  004a 0bb8          	dc.w	3000
  68  004c 0dac          	dc.w	3500
  69  004e 0f            	dc.b	15
  70  004f 0dac          	dc.w	3500
  71  0051 0dac          	dc.w	3500
  72  0053 14            	dc.b	20
  73  0054 0dac          	dc.w	3500
  74  0056 0fa0          	dc.w	4000
  75  0058 0f            	dc.b	15
  76  0059 0fa0          	dc.w	4000
  77  005b 0bb8          	dc.w	3000
  78  005d 1e            	dc.b	30
  79  005e 0000          	dc.w	0
  80  0060 0000          	dc.w	0
  81  0062 00            	dc.b	0
 118                     ; 72 void main(void)
 118                     ; 73 {
 120                     	switch	.text
 121  0000               _main:
 125                     ; 75 	LED_PORT->DDR = LED_MASK;
 127  0000 35f8500c      	mov	20492,#248
 128                     ; 76 	LED_PORT->CR1 = LED_MASK;
 130  0004 35f8500d      	mov	20493,#248
 131                     ; 77 	LED_PORT->ODR = LED_Tbl[LED_OFF];
 133  0008 35ff500a      	mov	20490,#255
 134                     ; 79 	Init_TIM2();
 136  000c cd0000        	call	_Init_TIM2
 138                     ; 81 	rim();
 141  000f 9a            rim
 143  0010               L13:
 144                     ; 85 		if(IR_State.Ready)
 146  0010 3d08          	tnz	_IR_State+8
 147  0012 27fc          	jreq	L13
 148                     ; 88 			switch(IR_State.Byte[IR_CMD])
 150  0014 b602          	ld	a,_IR_State+2
 152                     ; 106 				  break;
 153  0016 a015          	sub	a,#21
 154  0018 2710          	jreq	L3
 155  001a 4a            	dec	a
 156  001b 2718          	jreq	L5
 157  001d a002          	sub	a,#2
 158  001f 272a          	jreq	L11
 159  0021 a02a          	sub	a,#42
 160  0023 271b          	jreq	L7
 161  0025 4a            	dec	a
 162  0026 2723          	jreq	L11
 163  0028 2028          	jra	L14
 164  002a               L3:
 165                     ; 90 			  case IR_Right:
 165                     ; 91 					ServoStep.NextTable = Right_Tbl;
 167  002a ae004a        	ldw	x,#_Right_Tbl
 168  002d bf02          	ldw	_ServoStep+2,x
 169                     ; 92 					LED_PORT->ODR = LED_Tbl[LED_RIGHT]; 
 171  002f 355f500a      	mov	20490,#95
 172                     ; 93 					break;
 174  0033 201d          	jra	L14
 175  0035               L5:
 176                     ; 94 				case IR_Left:
 176                     ; 95 					ServoStep.NextTable = Left_Tbl;
 178  0035 ae0031        	ldw	x,#_Left_Tbl
 179  0038 bf02          	ldw	_ServoStep+2,x
 180                     ; 96 					LED_PORT->ODR = LED_Tbl[LED_LEFT]; 
 182  003a 358f500a      	mov	20490,#143
 183                     ; 97 					break;
 185  003e 2012          	jra	L14
 186  0040               L7:
 187                     ; 98 				case IR_Up:
 187                     ; 99 					ServoStep.NextTable = Forward_Tbl;
 189  0040 ae000e        	ldw	x,#_Forward_Tbl
 190  0043 bf02          	ldw	_ServoStep+2,x
 191                     ; 100 					LED_PORT->ODR = LED_Tbl[LED_FORWARD];
 193  0045 3517500a      	mov	20490,#23
 194                     ; 101 					break;
 196  0049 2007          	jra	L14
 197  004b               L11:
 198                     ; 102 				case IR_Down:
 198                     ; 103 				case IR_Select:
 198                     ; 104 					ServoStep.NextTable = NULL;
 200  004b 5f            	clrw	x
 201  004c bf02          	ldw	_ServoStep+2,x
 202                     ; 105 					LED_PORT->ODR = LED_Tbl[LED_OFF];
 204  004e 35ff500a      	mov	20490,#255
 205                     ; 106 				  break;
 207  0052               L14:
 208                     ; 109 			IR_State.Ready = 0;
 210  0052 3f08          	clr	_IR_State+8
 211  0054 20ba          	jra	L13
 312                     	xdef	_main
 313                     	xdef	_Right_Tbl
 314                     	xdef	_Left_Tbl
 315                     	xdef	_Forward_Tbl
 316                     	xdef	_LED_Tbl
 317                     	xdef	_Neutral
 318                     	xref.b	_IR_State
 319                     	xref	_Init_TIM2
 320                     	xref.b	_ServoStep
 339                     	end
