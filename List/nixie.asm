
;CodeVisionAVR C Compiler V2.05.3 Professional
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ds18b20_devices=R5
	.DEF _currentSensor=R4
	.DEF _ANODE_MASK=R7
	.DEF _CATODE_MASK=R6
	.DEF _cur_dig=R9
	.DEF _displayCounter=R8
	.DEF _displayDigit=R11
	.DEF _seconds=R10
	.DEF _minutes=R13
	.DEF _hours=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_conv_delay_G000:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G000:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF
_digit_G000:
	.DB  0x0,0x1,0x4,0x5,0x8,0x9,0xC,0xD
	.DB  0x2,0x3
_commonPins_G000:
	.DB  0x1,0x2,0x4,0x8

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x67:
	.DB  0xF0,0xF0,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x06
	.DW  _0x67*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#asm
.equ __w1_port=0x15
.equ __w1_bit=3
; 0000 0004 #endasm
;#include <1wire.h>
;#include "ds18b20.h"

	.CSEG
_ds18b20_select:
	RCALL SUBOPT_0x0
	ST   -Y,R17
;	*addr -> Y+1
;	i -> R17
	RCALL _w1_init
	CPI  R30,0
	BRNE _0x3
	LDI  R30,LOW(0)
	RJMP _0x2000003
_0x3:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x4
	cli
	LDI  R26,LOW(85)
	RCALL _w1_write
	sei
	LDI  R17,LOW(0)
_0x6:
	cli
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R26,R30
	RCALL _w1_write
	sei
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x6
	RJMP _0x8
_0x4:
	cli
	LDI  R26,LOW(204)
	RCALL _w1_write
	sei
_0x8:
	LDI  R30,LOW(1)
	RJMP _0x2000003
_ds18b20_read:
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR4
;	*addr -> Y+4
;	i -> R17
;	*p -> R18,R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x9
	LDI  R30,LOW(0)
	RJMP _0x2000004
_0x9:
	cli
	LDI  R26,LOW(190)
	RCALL _w1_write
	sei
	LDI  R17,LOW(0)
	__POINTWRM 18,19,_ds18b20_scratch
_0xB:
	cli
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	RCALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	sei
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0xB
	LDI  R30,LOW(_ds18b20_scratch)
	LDI  R31,HIGH(_ds18b20_scratch)
	RCALL SUBOPT_0x1
	LDI  R26,LOW(9)
	RCALL _w1_dow_crc8
	RCALL __LNEGB1
_0x2000004:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
_ds18b20_temperature:
	RCALL SUBOPT_0x0
	ST   -Y,R17
;	*addr -> Y+1
;	resolution -> R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0xD
	LDI  R30,LOW(55537)
	LDI  R31,HIGH(55537)
	RJMP _0x2000003
_0xD:
	__GETB1MN _ds18b20_scratch,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	cli
	LDI  R26,LOW(68)
	RCALL _w1_write
	sei
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G000*2)
	LDI  R27,HIGH(_conv_delay_G000*2)
	RCALL SUBOPT_0x2
	RCALL __GETW2PF
	RCALL _delay_ms
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_read
	CPI  R30,0
	BRNE _0xE
	LDI  R30,LOW(55537)
	LDI  R31,HIGH(55537)
	RJMP _0x2000003
_0xE:
	cli
	RCALL _w1_init
	sei
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G000*2)
	LDI  R27,HIGH(_bit_mask_G000*2)
	RCALL SUBOPT_0x2
	RCALL __GETW1PF
	LDS  R26,_ds18b20_scratch
	LDS  R27,_ds18b20_scratch+1
	AND  R30,R26
	AND  R31,R27
_0x2000003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_ds18b20_temperature_struct:
	RCALL SUBOPT_0x0
	SBIW R28,8
	RCALL __SAVELOCR6
;	*addr -> Y+14
;	temperature -> R16,R17
;	temp -> R18,R19
;	j -> R21
;	result -> Y+6
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+7,R30
	STD  Y+8,R30
	STD  Y+9,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _ds18b20_temperature
	MOVW R16,R30
	LDI  R30,LOW(55537)
	LDI  R31,HIGH(55537)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0xF
	LDI  R30,LOW(1)
	STD  Y+6,R30
	MOVW R18,R16
	TST  R17
	BRPL _0x10
	STD  Y+7,R30
	MOVW R30,R18
	COM  R30
	COM  R31
	ADIW R30,1
	MOVW R18,R30
_0x10:
	MOVW R30,R18
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	RCALL __LSRW3
	STD  Y+8,R30
	MOVW R30,R18
	RCALL __LSRW4
	MOVW R18,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	LDI  R21,LOW(0)
_0x12:
	CPI  R21,8
	BRSH _0x13
	SBRS R18,0
	RJMP _0x14
	MOV  R30,R21
	LDI  R26,LOW(1)
	RCALL __LSLB12
	LDD  R26,Y+9
	ADD  R30,R26
	STD  Y+9,R30
_0x14:
	LSR  R19
	ROR  R18
	SUBI R21,-1
	RJMP _0x12
_0x13:
_0xF:
	MOVW R30,R28
	ADIW R30,6
	MOVW R26,R28
	ADIW R26,10
	LDI  R24,4
	RCALL __COPYMML
	MOVW R30,R28
	ADIW R30,10
	LDI  R24,4
	IN   R1,SREG
	CLI
	RCALL __LOADLOCR6
	ADIW R28,16
	RET
;
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "ds3231_twi.c"
;#include "ds3231_twi.h"
;
;void twi_start(void) {
; 0000 000B void twi_start(void) {
_twi_start:
;    TWCR = (1<<TWEA)|(1<<TWINT)|(1<<TWSTA)|(1<<TWEN);
	LDI  R30,LOW(228)
	OUT  0x36,R30
;
;    while (!(TWCR & (1<<TWINT)))  {; }
_0x15:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x15
;}
	RET
;
;void twi_stop(void) {
_twi_stop:
;    TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWSTO);
	LDI  R30,LOW(148)
	OUT  0x36,R30
;}
	RET
;
;void twi_write(unsigned char _data)
;{
_twi_write:
;    TWDR = _data;
	ST   -Y,R26
;	_data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
;    TWCR = (1<<TWINT)|(1<<TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
;
;    while (!(TWCR & (1<<TWINT))) {;}
_0x18:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x18
;}
	RJMP _0x2000002
;
;unsigned char twi_read(unsigned char _ack) {
_twi_read:
;    unsigned char _data;
;
;    if (_ack==1)
	ST   -Y,R26
	ST   -Y,R17
;	_ack -> Y+1
;	_data -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x1B
;    {
;        TWCR = (1<<TWEA)|(1<<TWINT) | (1<<TWEN);
	LDI  R30,LOW(196)
	RJMP _0x64
;    }
;    else
_0x1B:
;    {
;        TWCR = (1<<TWINT) | (1<<TWEN);
	LDI  R30,LOW(132)
_0x64:
	OUT  0x36,R30
;    }
;    while (!(TWCR & (1<<TWINT)))
_0x1D:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x1D
;    {
;    }
;    _data = TWDR;
	IN   R17,3
;    return _data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;   }
;
;unsigned char bcd (unsigned char data) {
_bcd:
;    return (((data & 0b11110000)>>4)*10 + (data & 0b00001111));
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	RCALL SUBOPT_0x3
	RCALL __ASRW4
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	RJMP _0x2000002
;}
; unsigned char decToBcd(unsigned char val)
; {
_decToBcd:
;   return ( (val/10*16) + (val%10) );
	ST   -Y,R26
;	val -> Y+0
	LD   R26,Y
	RCALL SUBOPT_0x4
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R22,R0
	LD   R26,Y
	RCALL SUBOPT_0x5
	ADD  R30,R22
	RJMP _0x2000002
; }
;
;
;
;void ds3231_init(void){
_ds3231_init:
;twi_start();                           //Кидаем команду "Cтарт" на шину I2C
	RCALL SUBOPT_0x6
;twi_write(DS3231_I2C_ADDRESS_WRITE);              // 104 is DS3231 device address
;twi_write(0x0E);                            //выставляемся в 14й байт
	LDI  R26,LOW(14)
	RCALL _twi_write
;twi_write(0b00000000);                       //сбрасываем контрольные регистры
	LDI  R26,LOW(0)
	RCALL _twi_write
;twi_write(0b10001000);                       //выставляем 1 на статус OSF и En32kHz
	LDI  R26,LOW(136)
	RCALL _twi_write
;twi_stop();
	RCALL _twi_stop
;
;
;}
	RET
;
;void rtc_get_time(unsigned char *secondsParam, unsigned char *minutesParam, unsigned char *hoursParam, unsigned char *dayParam, unsigned char *dateParam, unsigned char *monthParam, unsigned char *yearParam) {
_rtc_get_time:
;
;twi_start();                           //Кидаем команду "Cтарт" на шину I2C
	RCALL SUBOPT_0x0
;	*secondsParam -> Y+12
;	*minutesParam -> Y+10
;	*hoursParam -> Y+8
;	*dayParam -> Y+6
;	*dateParam -> Y+4
;	*monthParam -> Y+2
;	*yearParam -> Y+0
	RCALL SUBOPT_0x6
;twi_write(DS3231_I2C_ADDRESS_WRITE);              // 104 is DS3231 device address
;twi_write(0x00);
	LDI  R26,LOW(0)
	RCALL _twi_write
;twi_stop();
	RCALL _twi_stop
;
;twi_start();
	RCALL _twi_start
;	twi_write(DS3231_I2C_ADDRESS_READ);
	LDI  R26,LOW(209)
	RCALL _twi_write
;
;     *secondsParam = bcd(twi_read(1)); // get seconds
	RCALL SUBOPT_0x7
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x8
;     *minutesParam = bcd(twi_read(1)); // get minutes
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x8
;     *hoursParam   = bcd(twi_read(1));   // get hours
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL SUBOPT_0x8
;     *dayParam     = bcd(twi_read(1));
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x8
;     *dateParam    = bcd(twi_read(1));
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x8
;     *monthParam   = bcd(twi_read(1)); //temp month
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
;     *yearParam    = bcd(twi_read(0));
	LDI  R26,LOW(0)
	RCALL _twi_read
	MOV  R26,R30
	RCALL _bcd
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
;
;twi_stop();
	RCALL _twi_stop
;}
	ADIW R28,14
	RET
;
;
;void rtc_set_time(unsigned char secondsParam, unsigned char minutesParam, unsigned char hoursParam, unsigned char dayParam, unsigned char dateParam, unsigned char monthParam, unsigned char yearParam) {
_rtc_set_time:
;    twi_start();
	ST   -Y,R26
;	secondsParam -> Y+6
;	minutesParam -> Y+5
;	hoursParam -> Y+4
;	dayParam -> Y+3
;	dateParam -> Y+2
;	monthParam -> Y+1
;	yearParam -> Y+0
	RCALL SUBOPT_0x6
;    twi_write(DS3231_I2C_ADDRESS_WRITE);
;    twi_write(0);
	LDI  R26,LOW(0)
	RCALL _twi_write
;    twi_write(decToBcd(secondsParam));
	LDD  R26,Y+6
	RCALL SUBOPT_0x9
;    twi_write(decToBcd(minutesParam));
	LDD  R26,Y+5
	RCALL SUBOPT_0x9
;    twi_write(decToBcd(hoursParam));
	LDD  R26,Y+4
	RCALL SUBOPT_0x9
;    twi_write(decToBcd(dayParam));
	LDD  R26,Y+3
	RCALL SUBOPT_0x9
;    twi_write(decToBcd(dateParam));
	LDD  R26,Y+2
	RCALL SUBOPT_0x9
;    twi_write(decToBcd(monthParam));
	LDD  R26,Y+1
	RCALL SUBOPT_0x9
;    twi_write(decToBcd(yearParam));
	LD   R26,Y
	RCALL SUBOPT_0x9
;    twi_stop();
	RCALL _twi_stop
;}
	ADIW R28,7
	RET
;
;
;
;
;//didits pins
;#define DIGIT_1  1
;#define DIGIT_2  2
;#define DIGIT_3  4
;#define DIGIT_4  8
;
;#define PIN_A  1
;#define PIN_B  4
;#define PIN_C  8
;#define PIN_D  2
;
;#define ZERO 0
;#define HALF 5
;
;#define PIN_DP PORTB.4
;
;#define PIN_DEBUG PORTB.5
;
;#define MODE_SHOW_MAIN_INFO 0
;#define MODE_SET_TIME_HOUR 1
;#define MODE_SET_TIME_MINUTE 2
;#define MODE_SET_TIME_SECONDS 3
;
;#define MODE_SHOW_SECONDS 4
;#define MODE_SHOW_TEMPERATURE 5
;
;
;#define BTN1 PINC.0
;#define BTN2 PINC.1
;
;#define CHECK_BTN_COUNT 3
;
;#define PORT_ANODE PORTD
;#define PORT_CATODE PORTB
;
;
;#define BLANK_DIGIT 10
;
;#define MAX_DS18b20 4
;
;ds18b20_temperature_data_struct temperature;
;unsigned char ds18b20_devices;
;unsigned char rom_code[MAX_DS18b20][9];
;unsigned char currentSensor;
;
;
;
;static flash unsigned char digit[] = {
;	0,
;	PIN_A,
;	PIN_B,
;	PIN_B + PIN_A,
;	PIN_C,
;	PIN_C + PIN_A,
;	PIN_C + PIN_B,
;	PIN_C + PIN_B + PIN_A,
;	PIN_D,
;	PIN_D + PIN_A
;};
;
;static flash unsigned char commonPins[] = {
;	DIGIT_1,
;	DIGIT_2,
;	DIGIT_3,
;	DIGIT_4
;};
;
;
;unsigned char ANODE_MASK = 0b11111111 ^ (DIGIT_1 + DIGIT_2 + DIGIT_3 + DIGIT_4);
;unsigned char CATODE_MASK = 0b11111111 ^ (PIN_A + PIN_B + PIN_C + PIN_D);
;
;unsigned char digit_out[4], cur_dig = 0;
;unsigned char displayCounter = 0;
;unsigned char displayDigit = 0;
;
;unsigned char seconds;
;unsigned char minutes;
;unsigned char hours;
;unsigned char day;
;unsigned char date;
;unsigned char month;
;unsigned char year;
;
;unsigned char btn1Counter = 0;
;unsigned char btn2Counter = 0;
;
;
;unsigned char mode;
;unsigned char prevLastDigit;
;unsigned char lastDigit;
;bit show_point;
;bit lastDigitChanged;
;
;
;
;void doBtn1Action(void) {
; 0000 006D void doBtn1Action(void) {
_doBtn1Action:
; 0000 006E 	mode = mode < 5 ? (mode + 1) : 0;
	LDS  R26,_mode
	CPI  R26,LOW(0x5)
	BRSH _0x20
	RCALL SUBOPT_0xA
	ADIW R30,1
	RJMP _0x21
_0x20:
	LDI  R30,LOW(0)
_0x21:
	STS  _mode,R30
; 0000 006F }
	RET
;
;void doBtn2Action(void) {
; 0000 0071 void doBtn2Action(void) {
_doBtn2Action:
; 0000 0072 	switch (mode) {
	RCALL SUBOPT_0xA
; 0000 0073 		case MODE_SHOW_MAIN_INFO:
	SBIW R30,0
	BRNE _0x26
; 0000 0074 			mode = MODE_SHOW_TEMPERATURE;
	LDI  R30,LOW(5)
	RJMP _0x65
; 0000 0075 			break;
; 0000 0076 		case MODE_SET_TIME_HOUR:
_0x26:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x27
; 0000 0077 			hours = hours < 23 ? (hours + 1) : 0;
	LDI  R30,LOW(23)
	CP   R12,R30
	BRSH _0x28
	MOV  R30,R12
	RCALL SUBOPT_0x3
	ADIW R30,1
	RJMP _0x29
_0x28:
	LDI  R30,LOW(0)
_0x29:
	MOV  R12,R30
; 0000 0078 			rtc_set_time(seconds, minutes, hours, day, date, month, year);
	RCALL SUBOPT_0xB
; 0000 0079 			break;
	RJMP _0x25
; 0000 007A 		case MODE_SET_TIME_MINUTE:
_0x27:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B
; 0000 007B 			minutes = minutes < 59 ? (minutes + 1) : 0;
	LDI  R30,LOW(59)
	CP   R13,R30
	BRSH _0x2C
	MOV  R30,R13
	RCALL SUBOPT_0x3
	ADIW R30,1
	RJMP _0x2D
_0x2C:
	LDI  R30,LOW(0)
_0x2D:
	MOV  R13,R30
; 0000 007C 			rtc_set_time(seconds, minutes, hours, day, date, month, year);
	RCALL SUBOPT_0xB
; 0000 007D 			break;
	RJMP _0x25
; 0000 007E 		case MODE_SET_TIME_SECONDS:
_0x2B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2F
; 0000 007F 			seconds = 0;
	CLR  R10
; 0000 0080 			rtc_set_time(seconds, minutes, hours, day, date, month, year);
	RCALL SUBOPT_0xB
; 0000 0081 			break;
	RJMP _0x25
; 0000 0082 		case MODE_SHOW_TEMPERATURE:
_0x2F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x25
; 0000 0083 			mode = MODE_SHOW_MAIN_INFO;
	LDI  R30,LOW(0)
_0x65:
	STS  _mode,R30
; 0000 0084 			break;
; 0000 0085 	}
_0x25:
; 0000 0086 }
	RET
;
;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
; 0000 008B interrupt [9] void timer1_ovf_isr(void) {
_timer1_ovf_isr:
	RCALL SUBOPT_0xC
; 0000 008C 	if(!BTN1) {
	SBIC 0x13,0
	RJMP _0x31
; 0000 008D 		btn1Counter++;
	LDS  R30,_btn1Counter
	SUBI R30,-LOW(1)
	STS  _btn1Counter,R30
; 0000 008E 		if(btn1Counter == CHECK_BTN_COUNT) {
	LDS  R26,_btn1Counter
	CPI  R26,LOW(0x3)
	BRNE _0x32
; 0000 008F 			doBtn1Action();
	RCALL _doBtn1Action
; 0000 0090 			btn1Counter = 0;
	LDI  R30,LOW(0)
	STS  _btn1Counter,R30
; 0000 0091 		}
; 0000 0092 	} else {
_0x32:
	RJMP _0x33
_0x31:
; 0000 0093 		btn1Counter = 0;
	LDI  R30,LOW(0)
	STS  _btn1Counter,R30
; 0000 0094 	}
_0x33:
; 0000 0095 
; 0000 0096 	if(!BTN2) {
	SBIC 0x13,1
	RJMP _0x34
; 0000 0097 		btn2Counter++;
	LDS  R30,_btn2Counter
	SUBI R30,-LOW(1)
	STS  _btn2Counter,R30
; 0000 0098 		if(btn2Counter == CHECK_BTN_COUNT) {
	LDS  R26,_btn2Counter
	CPI  R26,LOW(0x3)
	BRNE _0x35
; 0000 0099 			doBtn2Action();
	RCALL _doBtn2Action
; 0000 009A 			btn2Counter = 0;
	LDI  R30,LOW(0)
	STS  _btn2Counter,R30
; 0000 009B 		}
; 0000 009C 	} else {
_0x35:
	RJMP _0x36
_0x34:
; 0000 009D 		btn2Counter = 0;
	LDI  R30,LOW(0)
	STS  _btn2Counter,R30
; 0000 009E 	}
_0x36:
; 0000 009F 	TCNT1=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 00A0 }
	RJMP _0x66
;
;
;void showInfo() {
; 0000 00A3 void showInfo() {
_showInfo:
; 0000 00A4 
; 0000 00A5  if(displayCounter == 0) {
	TST  R8
	BREQ PC+2
	RJMP _0x37
; 0000 00A6   unsigned char anodeVar = PORT_ANODE & ANODE_MASK;
; 0000 00A7   unsigned char catodeVar = PORT_CATODE & CATODE_MASK;
; 0000 00A8 
; 0000 00A9   PORT_CATODE &= CATODE_MASK;
	SBIW R28,2
;	anodeVar -> Y+1
;	catodeVar -> Y+0
	IN   R30,0x12
	AND  R30,R7
	STD  Y+1,R30
	IN   R30,0x18
	AND  R30,R6
	ST   Y,R30
	IN   R30,0x18
	AND  R30,R6
	OUT  0x18,R30
; 0000 00AA   PORT_ANODE &= ANODE_MASK;
	IN   R30,0x12
	AND  R30,R7
	OUT  0x12,R30
; 0000 00AB 
; 0000 00AC 
; 0000 00AD   displayDigit = digit_out[cur_dig];
	MOV  R30,R9
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_digit_out)
	SBCI R31,HIGH(-_digit_out)
	LD   R11,Z
; 0000 00AE   if(displayDigit < 10) {
	LDI  R30,LOW(10)
	CP   R11,R30
	BRSH _0x38
; 0000 00AF    catodeVar |= digit[displayDigit];
	MOV  R30,R11
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	LPM  R30,Z
	LD   R26,Y
	OR   R30,R26
	ST   Y,R30
; 0000 00B0    anodeVar |= commonPins[cur_dig];
	MOV  R30,R9
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_commonPins_G000*2)
	SBCI R31,HIGH(-_commonPins_G000*2)
	LPM  R30,Z
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
; 0000 00B1    PORT_CATODE = catodeVar;
	LD   R30,Y
	OUT  0x18,R30
; 0000 00B2    PORT_ANODE = anodeVar;
	LDD  R30,Y+1
	OUT  0x12,R30
; 0000 00B3    PIN_DEBUG = ~PIN_DEBUG;
	SBIS 0x18,5
	RJMP _0x39
	CBI  0x18,5
	RJMP _0x3A
_0x39:
	SBI  0x18,5
_0x3A:
; 0000 00B4   }
; 0000 00B5   //delay_ms(100);
; 0000 00B6 
; 0000 00B7   if(cur_dig == 2 && mode == MODE_SHOW_MAIN_INFO) {
_0x38:
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x3C
	LDS  R26,_mode
	CPI  R26,LOW(0x0)
	BREQ _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
; 0000 00B8    PIN_DP = show_point;
	SBRC R2,0
	RJMP _0x3E
	CBI  0x18,4
	RJMP _0x3F
_0x3E:
	SBI  0x18,4
_0x3F:
; 0000 00B9   } else {
	RJMP _0x40
_0x3B:
; 0000 00BA    PIN_DP = 0;
	CBI  0x18,4
; 0000 00BB   }
_0x40:
; 0000 00BC 
; 0000 00BD 
; 0000 00BE   cur_dig++;
	INC  R9
; 0000 00BF   if (cur_dig > 3) {
	LDI  R30,LOW(3)
	CP   R30,R9
	BRSH _0x43
; 0000 00C0    cur_dig = 0;
	CLR  R9
; 0000 00C1   }
; 0000 00C2  }
_0x43:
	ADIW R28,2
; 0000 00C3 }
_0x37:
	RET
;
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void) {
; 0000 00C7 interrupt [5] void timer2_ovf_isr(void) {
_timer2_ovf_isr:
	RCALL SUBOPT_0xC
; 0000 00C8 	showInfo();
	RCALL _showInfo
; 0000 00C9 }
_0x66:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;unsigned char nextDigit(unsigned char digit) {
; 0000 00CB unsigned char nextDigit(unsigned char digit) {
_nextDigit:
; 0000 00CC 	return (digit + 1) % 10;
	ST   -Y,R26
;	digit -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x3
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
_0x2000002:
	ADIW R28,1
	RET
; 0000 00CD }
;
;void view_term(void) {
; 0000 00CF void view_term(void) {
_view_term:
; 0000 00D0 	unsigned char decades;
; 0000 00D1 	decades = temperature.temperatureIntValue / 10;
	ST   -Y,R17
;	decades -> R17
	__GETB2MN _temperature,3
	RCALL SUBOPT_0x4
	MOV  R17,R30
; 0000 00D2 	digit_out[0] = decades > 0 ? decades : BLANK_DIGIT;
	CPI  R17,1
	BRLO _0x44
	MOV  R30,R17
	RJMP _0x45
_0x44:
	LDI  R30,LOW(10)
_0x45:
	RCALL SUBOPT_0xD
; 0000 00D3 	digit_out[1] = temperature.temperatureIntValue % 10;
	__GETB2MN _temperature,3
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xE
; 0000 00D4 	digit_out[2] = temperature.halfDegree ? HALF : ZERO;
	__GETB1MN _temperature,2
	CPI  R30,0
	BREQ _0x47
	LDI  R30,LOW(5)
	RJMP _0x48
_0x47:
	LDI  R30,LOW(0)
_0x48:
	RCALL SUBOPT_0xF
; 0000 00D5 	digit_out[3] = BLANK_DIGIT;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x10
; 0000 00D6 }
	RJMP _0x2000001
;
;void displayMainInfo() {
; 0000 00D8 void displayMainInfo() {
_displayMainInfo:
; 0000 00D9     unsigned char j = 0;
; 0000 00DA 	if(lastDigitChanged) {
	ST   -Y,R17
;	j -> R17
	LDI  R17,0
	SBRS R2,1
	RJMP _0x4A
; 0000 00DB 		for(j = 0; j < 10; j++) {
	LDI  R17,LOW(0)
_0x4C:
	CPI  R17,10
	BRSH _0x4D
; 0000 00DC 			digit_out[0] = nextDigit(digit_out[0]);
	LDS  R26,_digit_out
	RCALL _nextDigit
	RCALL SUBOPT_0xD
; 0000 00DD 			digit_out[1] = nextDigit(digit_out[1]);
	__GETB2MN _digit_out,1
	RCALL _nextDigit
	RCALL SUBOPT_0xE
; 0000 00DE 			digit_out[2] = nextDigit(digit_out[2]);
	__GETB2MN _digit_out,2
	RCALL _nextDigit
	RCALL SUBOPT_0xF
; 0000 00DF 			digit_out[3] = nextDigit(digit_out[3]);
	__GETB2MN _digit_out,3
	RCALL _nextDigit
	RCALL SUBOPT_0x10
; 0000 00E0 			delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 00E1 		}
	SUBI R17,-1
	RJMP _0x4C
_0x4D:
; 0000 00E2 		lastDigitChanged = 0;
	CLT
	BLD  R2,1
; 0000 00E3 	} else {
	RJMP _0x4E
_0x4A:
; 0000 00E4 		digit_out[0] = hours / 10;
	MOV  R26,R12
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xD
; 0000 00E5 		digit_out[1] = hours % 10;
	MOV  R26,R12
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xE
; 0000 00E6 		digit_out[2] = minutes / 10;
	MOV  R26,R13
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xF
; 0000 00E7 		lastDigit = minutes % 10;
	MOV  R26,R13
	RCALL SUBOPT_0x5
	STS  _lastDigit,R30
; 0000 00E8 
; 0000 00E9 		lastDigitChanged = prevLastDigit != lastDigit;
	LDS  R26,_prevLastDigit
	RCALL __NEB12
	BST  R30,0
	BLD  R2,1
; 0000 00EA 		prevLastDigit = lastDigit;
	LDS  R30,_lastDigit
	STS  _prevLastDigit,R30
; 0000 00EB 		digit_out[3] = lastDigit;
	LDS  R30,_lastDigit
	RCALL SUBOPT_0x10
; 0000 00EC 	}
_0x4E:
; 0000 00ED }
_0x2000001:
	LD   R17,Y+
	RET
;
;void displayInfo(void) {
; 0000 00EF void displayInfo(void) {
_displayInfo:
; 0000 00F0 	switch (mode) {
	RCALL SUBOPT_0xA
; 0000 00F1 	case MODE_SHOW_MAIN_INFO:
	SBIW R30,0
	BRNE _0x52
; 0000 00F2 		displayMainInfo();
	RCALL _displayMainInfo
; 0000 00F3 		break;
	RJMP _0x51
; 0000 00F4 	case MODE_SET_TIME_HOUR:
_0x52:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x53
; 0000 00F5 		digit_out[0] = 8;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0xD
; 0000 00F6 		digit_out[1] = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xE
; 0000 00F7 		digit_out[2] = hours / 10;
	MOV  R26,R12
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xF
; 0000 00F8 		digit_out[3] = hours % 10;
	MOV  R26,R12
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x10
; 0000 00F9 		break;
	RJMP _0x51
; 0000 00FA 	case MODE_SET_TIME_MINUTE:
_0x53:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x54
; 0000 00FB 		digit_out[0] = 8;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0xD
; 0000 00FC 		digit_out[1] = 2;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xE
; 0000 00FD 		digit_out[2] = minutes / 10;
	MOV  R26,R13
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xF
; 0000 00FE 		digit_out[3] = minutes % 10;
	MOV  R26,R13
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x10
; 0000 00FF 		break;
	RJMP _0x51
; 0000 0100 	case MODE_SET_TIME_SECONDS:
_0x54:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x55
; 0000 0101 		digit_out[0] = 8;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0xD
; 0000 0102 		digit_out[1] = 3;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xE
; 0000 0103 		digit_out[2] = seconds / 10;
	MOV  R26,R10
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xF
; 0000 0104 		digit_out[3] = seconds % 10;
	MOV  R26,R10
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x10
; 0000 0105 		break;
	RJMP _0x51
; 0000 0106 	case MODE_SHOW_SECONDS:
_0x55:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x56
; 0000 0107 		digit_out[0] = BLANK_DIGIT;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0xD
; 0000 0108 		digit_out[1] = BLANK_DIGIT;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0xE
; 0000 0109 		digit_out[2] = seconds / 10;
	MOV  R26,R10
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xF
; 0000 010A 		digit_out[3] = seconds % 10;
	MOV  R26,R10
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x10
; 0000 010B 		break;
	RJMP _0x51
; 0000 010C 	case MODE_SHOW_TEMPERATURE:
_0x56:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x51
; 0000 010D 		view_term();
	RCALL _view_term
; 0000 010E 		break;
; 0000 010F 	}
_0x51:
; 0000 0110 }
	RET
;
;void main(void)
; 0000 0113 {
_main:
; 0000 0114 // Declare your local variables here
; 0000 0115 	unsigned char i = 0;
; 0000 0116     int tmp_counter;
; 0000 0117 
; 0000 0118 	PORTB = 0xFF;
;	i -> R17
;	tmp_counter -> R18,R19
	LDI  R17,0
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0119 	DDRB = 0xFF;
	OUT  0x17,R30
; 0000 011A 
; 0000 011B 	PORTC = 0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
; 0000 011C 	DDRC = 0xF8;
	LDI  R30,LOW(248)
	OUT  0x14,R30
; 0000 011D 
; 0000 011E 	PORTD = 0xFF;;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 011F 	DDRD = 0xFF;
	OUT  0x11,R30
; 0000 0120 
; 0000 0121 
; 0000 0122 // Timer/Counter 0 initialization
; 0000 0123 // Clock source: System Clock
; 0000 0124 // Clock value: Timer 0 Stopped
; 0000 0125 	TCCR0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0126 	TCNT0 = 0x00;
	OUT  0x32,R30
; 0000 0127 
; 0000 0128 	// Timer/Counter 1 initialization
; 0000 0129 	// Clock source: System Clock
; 0000 012A 	// Clock value: 7,813 kHz
; 0000 012B 	// Mode: Normal top=0xFFFF
; 0000 012C 	// OC1A output: Discon.
; 0000 012D 	// OC1B output: Discon.
; 0000 012E 	// Noise Canceler: Off
; 0000 012F 	// Input Capture on Falling Edge
; 0000 0130 	// Timer1 Overflow Interrupt: On
; 0000 0131 	// Input Capture Interrupt: Off
; 0000 0132 	// Compare A Match Interrupt: Off
; 0000 0133 	// Compare B Match Interrupt: Off
; 0000 0134 	TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0135 	TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0136 	TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0137 	TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0138 	ICR1H=0x00;
	OUT  0x27,R30
; 0000 0139 	ICR1L=0x00;
	OUT  0x26,R30
; 0000 013A 	OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 013B 	OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 013C 	OCR1BH=0x00;
	OUT  0x29,R30
; 0000 013D 	OCR1BL=0x00;
	OUT  0x28,R30
; 0000 013E 
; 0000 013F 
; 0000 0140 // Timer/Counter 2 initialization
; 0000 0141 // Clock source: System Clock
; 0000 0142 // Clock value: 62,500 kHz
; 0000 0143 // Mode: Normal top=0xFF
; 0000 0144 // OC2 output: Disconnected
; 0000 0145 ASSR = 0x00;
	OUT  0x22,R30
; 0000 0146 TCCR2 = 0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 0147 TCNT2 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0148 OCR2 = 0x00;
	OUT  0x23,R30
; 0000 0149 
; 0000 014A // External Interrupt(s) initialization
; 0000 014B // INT0: Off
; 0000 014C // INT1: Off
; 0000 014D MCUCR=0x00;
	OUT  0x35,R30
; 0000 014E 
; 0000 014F // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0150 TIMSK = 0x44;
	LDI  R30,LOW(68)
	OUT  0x39,R30
; 0000 0151 
; 0000 0152 
; 0000 0153 // USART initialization
; 0000 0154 // USART disabled
; 0000 0155 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0156 
; 0000 0157 // Analog Comparator initialization
; 0000 0158 // Analog Comparator: Off
; 0000 0159 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 015A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 015B SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 015C 
; 0000 015D // ADC initialization
; 0000 015E // ADC disabled
; 0000 015F ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0160 
; 0000 0161 // SPI initialization
; 0000 0162 // SPI disabled
; 0000 0163 SPCR=0x00;
	OUT  0xD,R30
; 0000 0164 
; 0000 0165 
; 0000 0166 // TWI initialization
; 0000 0167 // TWI disabled
; 0000 0168 TWBR = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x0,R30
; 0000 0169 TWAR = 0xD0;
	LDI  R30,LOW(208)
	OUT  0x2,R30
; 0000 016A TWCR = 0x44;
	LDI  R30,LOW(68)
	OUT  0x36,R30
; 0000 016B 
; 0000 016C w1_init();
	RCALL _w1_init
; 0000 016D ds18b20_devices = w1_search(0xf0, rom_code);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R26,LOW(_rom_code)
	LDI  R27,HIGH(_rom_code)
	RCALL _w1_search
	MOV  R5,R30
; 0000 016E 
; 0000 016F // Global enable interrupts
; 0000 0170 #asm("sei")
	sei
; 0000 0171 //skip first values
; 0000 0172  	if (ds18b20_devices >= 0) {
	LDI  R30,LOW(0)
	CP   R5,R30
	BRLO _0x58
; 0000 0173  		for (i = 0; i < ds18b20_devices; i++) {
	LDI  R17,LOW(0)
_0x5A:
	CP   R17,R5
	BRSH _0x5B
; 0000 0174  			ds18b20_temperature(&rom_code[i][0]);
	LDI  R26,LOW(9)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_rom_code)
	SBCI R31,HIGH(-_rom_code)
	MOVW R26,R30
	RCALL _ds18b20_temperature
; 0000 0175  		}
	SUBI R17,-1
	RJMP _0x5A
_0x5B:
; 0000 0176  	}
; 0000 0177 
; 0000 0178 
; 0000 0179 
; 0000 017A digit_out[0] = ds18b20_devices;
_0x58:
	STS  _digit_out,R5
; 0000 017B digit_out[1] = BLANK_DIGIT;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0xE
; 0000 017C digit_out[2] = ds18b20_devices;
	__PUTBMRN _digit_out,2,5
; 0000 017D digit_out[3] = BLANK_DIGIT;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x10
; 0000 017E 
; 0000 017F ds3231_init();
	RCALL _ds3231_init
; 0000 0180 rtc_get_time(&seconds, &minutes, &hours, &day, &date, &month, &year);
	RCALL SUBOPT_0x11
; 0000 0181 
; 0000 0182 
; 0000 0183 	tmp_counter = 0;
	__GETWRN 18,19,0
; 0000 0184 		while (1) {
_0x5C:
; 0000 0185 			rtc_get_time(&seconds, &minutes, &hours, &day, &date, &month, &year);
	RCALL SUBOPT_0x11
; 0000 0186 			tmp_counter++;
	__ADDWRN 18,19,1
; 0000 0187 			if(tmp_counter % 5 == 0) {
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL __MODW21
	SBIW R30,0
	BRNE _0x5F
; 0000 0188 				show_point = ~show_point;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 0189 			}
; 0000 018A 
; 0000 018B 			displayInfo();
_0x5F:
	RCALL _displayInfo
; 0000 018C 
; 0000 018D 			delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 018E 
; 0000 018F             if(tmp_counter == 150) {
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x60
; 0000 0190             if (ds18b20_devices >= 1) {
	LDI  R30,LOW(1)
	CP   R5,R30
	BRLO _0x61
; 0000 0191             temperature = ds18b20_temperature_struct(&rom_code[currentSensor][0]);
	MOV  R30,R4
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_rom_code)
	SBCI R31,HIGH(-_rom_code)
	MOVW R26,R30
	RCALL _ds18b20_temperature_struct
	LDI  R26,LOW(_temperature)
	LDI  R27,HIGH(_temperature)
	RCALL __COPYMML
	OUT  SREG,R1
; 0000 0192 currentSensor++;
	INC  R4
; 0000 0193 	 		if (currentSensor >= ds18b20_devices) {
	CP   R4,R5
	BRLO _0x62
; 0000 0194 	 			currentSensor = 0;
	CLR  R4
; 0000 0195 	 		}
; 0000 0196 
; 0000 0197             }
_0x62:
; 0000 0198             tmp_counter = 0;
_0x61:
	__GETWRN 18,19,0
; 0000 0199             }
; 0000 019A 		}
_0x60:
	RJMP _0x5C
; 0000 019B 
; 0000 019C }
_0x63:
	RJMP _0x63
;

	.DSEG
_ds18b20_scratch:
	.BYTE 0x9
_temperature:
	.BYTE 0x4
_rom_code:
	.BYTE 0x24
_digit_out:
	.BYTE 0x4
_day:
	.BYTE 0x1
_date:
	.BYTE 0x1
_month:
	.BYTE 0x1
_year:
	.BYTE 0x1
_btn1Counter:
	.BYTE 0x1
_btn2Counter:
	.BYTE 0x1
_mode:
	.BYTE 0x1
_prevLastDigit:
	.BYTE 0x1
_lastDigit:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x3:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	RCALL _twi_start
	LDI  R26,LOW(208)
	RJMP _twi_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(1)
	RCALL _twi_read
	MOV  R26,R30
	RJMP _bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	ST   X,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	RCALL _decToBcd
	MOV  R26,R30
	RJMP _twi_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDS  R30,_mode
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xB:
	ST   -Y,R10
	ST   -Y,R13
	ST   -Y,R12
	LDS  R30,_day
	ST   -Y,R30
	LDS  R30,_date
	ST   -Y,R30
	LDS  R30,_month
	ST   -Y,R30
	LDS  R26,_year
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	STS  _digit_out,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	__PUTB1MN _digit_out,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	__PUTB1MN _digit_out,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	__PUTB1MN _digit_out,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(_day)
	LDI  R31,HIGH(_day)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(_date)
	LDI  R31,HIGH(_date)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(_month)
	LDI  R31,HIGH(_month)
	RCALL SUBOPT_0x1
	LDI  R26,LOW(_year)
	LDI  R27,HIGH(_year)
	RJMP _rtc_get_time


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	push r26
	ld   r26,y
	rcall _w1_write
	pop  r26
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,1
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	clr  r31
	add  r30,r26
	adc  r31,r27
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	ldd  r27,y+1
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,2
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
