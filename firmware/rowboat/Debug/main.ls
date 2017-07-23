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
  23  000a               _Forward_Tbl:
  24  000a 0bb8          	dc.w	3000
  25  000c 0fa0          	dc.w	4000
  26  000e 28            	dc.b	40
  27  000f 0fa0          	dc.w	4000
  28  0011 0bb8          	dc.w	3000
  29  0013 01            	dc.b	1
  30  0014 0bb8          	dc.w	3000
  31  0016 0bb8          	dc.w	3000
  32  0018 05            	dc.b	5
  33  0019 0bb8          	dc.w	3000
  34  001b 07d0          	dc.w	2000
  35  001d 28            	dc.b	40
  36  001e 07d0          	dc.w	2000
  37  0020 0bb8          	dc.w	3000
  38  0022 01            	dc.b	1
  39  0023 0bb8          	dc.w	3000
  40  0025 0bb8          	dc.w	3000
  41  0027 05            	dc.b	5
  42  0028 0000          	dc.w	0
  43  002a 0000          	dc.w	0
  44  002c 00            	dc.b	0
  45  002d               _Left_Tbl:
  46  002d 0bb8          	dc.w	3000
  47  002f 09c4          	dc.w	2500
  48  0031 0f            	dc.b	15
  49  0032 09c4          	dc.w	2500
  50  0034 09c4          	dc.w	2500
  51  0036 14            	dc.b	20
  52  0037 09c4          	dc.w	2500
  53  0039 07d0          	dc.w	2000
  54  003b 0f            	dc.b	15
  55  003c 07d0          	dc.w	2000
  56  003e 0bb8          	dc.w	3000
  57  0040 1e            	dc.b	30
  58  0041 0000          	dc.w	0
  59  0043 0000          	dc.w	0
  60  0045 00            	dc.b	0
  61  0046               _Right_Tbl:
  62  0046 0bb8          	dc.w	3000
  63  0048 0dac          	dc.w	3500
  64  004a 0f            	dc.b	15
  65  004b 0dac          	dc.w	3500
  66  004d 0dac          	dc.w	3500
  67  004f 14            	dc.b	20
  68  0050 0dac          	dc.w	3500
  69  0052 0fa0          	dc.w	4000
  70  0054 0f            	dc.b	15
  71  0055 0fa0          	dc.w	4000
  72  0057 0bb8          	dc.w	3000
  73  0059 1e            	dc.b	30
  74  005a 0000          	dc.w	0
  75  005c 0000          	dc.w	0
  76  005e 00            	dc.b	0
  77  005f               _Reverse_Tbl:
  78  005f 0bb8          	dc.w	3000
  79  0061 0fa0          	dc.w	4000
  80  0063 28            	dc.b	40
  81  0064 0fa0          	dc.w	4000
  82  0066 0d05          	dc.w	3333
  83  0068 01            	dc.b	1
  84  0069 0d05          	dc.w	3333
  85  006b 0d05          	dc.w	3333
  86  006d 05            	dc.b	5
  87  006e 0d05          	dc.w	3333
  88  0070 07d0          	dc.w	2000
  89  0072 28            	dc.b	40
  90  0073 07d0          	dc.w	2000
  91  0075 0a6b          	dc.w	2667
  92  0077 01            	dc.b	1
  93  0078 0a6b          	dc.w	2667
  94  007a 0a6b          	dc.w	2667
  95  007c 05            	dc.b	5
  96  007d 0a6b          	dc.w	2667
  97  007f 0bb8          	dc.w	3000
  98  0081 28            	dc.b	40
  99  0082 0000          	dc.w	0
 100  0084 0000          	dc.w	0
 101  0086 00            	dc.b	0
 134                     ; 82 void main(void)
 134                     ; 83 {
 136                     	switch	.text
 137  0000               _main:
 141                     ; 84 	Init_TIM2();
 143  0000 cd0000        	call	_Init_TIM2
 145                     ; 86 	rim();
 148  0003 9a            rim
 150                     ; 88 	ServoStep.Table = Forward_Tbl;
 153  0004 ae000a        	ldw	x,#_Forward_Tbl
 154  0007 bf00          	ldw	_ServoStep,x
 155  0009               L12:
 156                     ; 89 	while (1);
 158  0009 20fe          	jra	L12
 261                     	xdef	_main
 262                     	xdef	_Reverse_Tbl
 263                     	xdef	_Right_Tbl
 264                     	xdef	_Left_Tbl
 265                     	xref	_Init_TIM2
 266                     	xref.b	_ServoStep
 267                     	xdef	_Neutral
 268                     	xdef	_Forward_Tbl
 287                     	end
