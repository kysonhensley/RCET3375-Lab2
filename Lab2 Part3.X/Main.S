;==============================================================================
; Name: Kyson Hensley
; Course: RCET 3375
; Semester: 5th semester
; Assignment: PIC
; Device:      PIC16F883
; Toolchain:   MPLAB X + pic-as
; Git URL: https://github.com/kysonhensley/RCET3375-Lab2.git
; Linker Options:   -Wl,-presetVect=0000h,-pcode=0008h
;==============================================================================

    
; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>
  
  ; Reset Vector at 0000h. Execution starts here after reset.
PSECT resetVect,class=CODE,delta=2
ResetVector:            
    GOTO Setup

; Main code section starts at 0008h. User code goes here.
PSECT code,class=CODE,delta=2

;------------------------------------------------------------------------------
; Setup
;------------------------------------------------------------------------------
Setup:
    ; add device setup here
    
    ;PORTB Digital Inputs
    BSF STATUS, 6
    BSF STATUS, 5	;Bank 3
    CLRF ANSELH		;Clear ANSELH Register
    
    ;PORTC Digital Outputs
    CLRF ANSEL          ;PORTC digital
    
    BCF STATUS, 6
    BSF STATUS, 5	;Bank 1
    MOVLW 0xF0		;set bits RB0-RB3 as outputs and RB4-RB7 as inputs
    MOVWF TRISB		;move hex value to TRISB register
    CLRF TRISC          ;PORTC outputs
    BCF OPTION_REG, 7
    MOVLW 0xF0
    MOVWF WPUB		;activate weak pull up resistors for RB4-RB7
    
    BCF STATUS, 6
    BCF STATUS, 5	;Bank 0
    CLRF INTCON		;Clear INTCON Register
    CLRF PORTB		;Clear PORTB
    CLRF PORTC		;Clear PORTC
    
    GOTO Main

;------------------------------------------------------------------------------
; Main Loop
;------------------------------------------------------------------------------
Main:
    ; add main loop code here
    
    ;Clear 2 general purpose registers
    CLRF 0x20		;Clear general purpose register 20
    CLRF 0x21		;Clear general purpose register 21
    CLRF 0x22		;Clear general purpose register 22
    
    ;Scan row 1 of keypad (RB0)
    MOVLW 0xFE		;Make outputs high except for RB0
    MOVWF PORTB
    
    ;Read inputs
    MOVF PORTB, W
    MOVWF 0x22
    
    BTFSS 0x22, 4
    BSF 0x20, 1		;1 was pressed

    BTFSS 0x22, 5
    BSF 0x20, 2		;2 was pressed

    BTFSS 0x22, 6
    BSF 0x20, 3		;3 was pressed

    BTFSS 0x22, 7
    BSF 0x21, 2		;A was pressed
    
    ;Scan row 2 of keypad (RB1)
    MOVLW 0xFD
    MOVWF PORTB
    
    ;Read inputs
    MOVF PORTB, W
    MOVWF 0x22
    
    BTFSS 0x22, 4
    BSF 0x20, 4		;4 was pressed

    BTFSS 0x22, 5
    BSF 0x20, 5		;5 was pressed

    BTFSS 0x22, 6
    BSF 0x20, 6		;6 was pressed

    BTFSS 0x22, 7
    BSF 0x21, 3		 ;B was pressed
    
    ;Scan row 3 of keypad (RB2)
    MOVLW 0xFB
    MOVWF PORTB
    
    ;Read inputs
    MOVF PORTB, W
    MOVWF 0x22
    
    BTFSS 0x22, 4
    BSF 0x20, 7		  ;7 was pressed

    BTFSS 0x22, 5
    BSF 0x21, 0		 ;8 was pressed

    BTFSS 0x22, 6
    BSF 0x21, 1		 ;9 was pressed

    BTFSS 0x22, 7
    BSF 0x21, 4		 ;C was pressed
    
    ;Scan row 4 of keypad (RB3)
    MOVLW 0xF7
    MOVWF PORTB
    
    ;Read inputs
    MOVF PORTB, W
    MOVWF 0x22
    
    BTFSS 0x22, 4
    BSF 0x21, 6		 ;Star was pressed

    BTFSS 0x22, 5
    BSF 0x20, 0		 ;0 was pressed

    BTFSS 0x22, 6
    BSF 0x21, 7		 ;Pound was pressed

    BTFSS 0x22, 7
    BSF 0x21, 5		 ;D was pressed

    GOTO TestPound
    
    TestPound:
	BTFSS 0x21, 7
	GOTO TestStar
	GOTO DisplayPound
	
    TestStar:
	BTFSS 0x21, 6
	GOTO TestD
	GOTO DisplayStar
    
    TestD:
	BTFSS 0x21, 5
	GOTO TestC
	GOTO DisplayD
	
    TestC:
	BTFSS 0x21, 4
	GOTO TestB
	GOTO DisplayC
	
    TestB:
	BTFSS 0x21, 3
	GOTO TestA
	GOTO DisplayB
	
    TestA:
	BTFSS 0x21, 2
	GOTO Test9
	GOTO DisplayA
	
    Test9:
	BTFSS 0x21, 1
	GOTO Test8
	GOTO Display9
	
    Test8:
	BTFSS 0x21, 0
	GOTO Test7
	GOTO Display8
	
    Test7:
	BTFSS 0x20, 7
	GOTO Test6
	GOTO Display7
	
    Test6:
	BTFSS 0x20, 6
	GOTO Test5
	GOTO Display6
	
    Test5:
	BTFSS 0x20, 5
	GOTO Test4
	GOTO Display5
	
    Test4:
	BTFSS 0x20, 4
	GOTO Test3
	GOTO Display4
	
    Test3:
	BTFSS 0x20, 3
	GOTO Test2
	GOTO Display3
	
    Test2:
	BTFSS 0x20, 2
	GOTO Test1
	GOTO Display2
	
    Test1:
	BTFSS 0x20, 1
	GOTO Test0
	GOTO Display1
	
    Test0:
	BTFSS 0x20, 0
	GOTO Main
	GOTO Display0
	
    DisplayPound:
	MOVLW 0x23
	MOVWF PORTC
	GOTO Main
	
    DisplayStar:
	MOVLW 0x2A
	MOVWF PORTC
	GOTO Main
	
    DisplayD:
	MOVLW 0x44
	MOVWF PORTC
	GOTO Main
	
    DisplayC:
        MOVLW 0x43
	MOVWF PORTC
	GOTO Main
	
    DisplayB:
	MOVLW 0x42
	MOVWF PORTC
	GOTO Main
	
    DisplayA:
	MOVLW 0x41
	MOVWF PORTC
	GOTO Main
	
    Display9:
	MOVLW 0x39
	MOVWF PORTC
	GOTO Main
	
    Display8:
	MOVLW 0x38
	MOVWF PORTC
	GOTO Main
	
    Display7:
	MOVLW 0x37
	MOVWF PORTC
	GOTO Main
	
    Display6:
	MOVLW 0x36
	MOVWF PORTC
	GOTO Main
	
    Display5:
	MOVLW 0x35
	MOVWF PORTC
	GOTO Main
	
	
    Display4:
	MOVLW 0x34
	MOVWF PORTC
	GOTO Main
	
	
    Display3:
	MOVLW 0x33
	MOVWF PORTC
	GOTO Main
	
    Display2:
	MOVLW 0x32
	MOVWF PORTC
	GOTO Main
	
    Display1:
	MOVLW 0x31
	MOVWF PORTC
	GOTO Main
	
    Display0:
	MOVLW 0x31
	MOVWF PORTC
	GOTO Main
	