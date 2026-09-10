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
    goto Setup

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
    
    BCF STATUS, 6
    BSF STATUS, 5	;Bank 1
    MOVLW 0xFF		
    MOVWF TRISB
    
    BCF STATUS, 6
    BCF STATUS, 5	;Bank 0
    CLRF INTCON		;Clear INTCON Register
    
    CLRF PORTB		;Clear PORTB
    
    ;PORTC Digital Outputs
    BSF STATUS, 6
    BSF STATUS, 5       ;Bank 3
    CLRF ANSEL           ;PORTC digital

    BCF STATUS, 6
    BSF STATUS, 5       ;Bank 1
    CLRF TRISC           ;PORTC outputs

    BCF STATUS, 6
    BCF STATUS, 5       ;Bank 0
    CLRF PORTC		;Clear PORTC
    
    goto Main

;------------------------------------------------------------------------------
; Main Loop
;------------------------------------------------------------------------------
Main:
    ; add main loop code here
    
    ;Test each bit jumpto correct display code
    BTFSC PORTB, 7	;Test bit 7
    goto Display7	;goto Display7 code
    
    BTFSC PORTB, 6	;Test bit 6
    goto Display6	;goto Display6 code
    
    BTFSC PORTB, 5	;Test bit 5
    goto Display5	;goto Display5 code
    
    BTFSC PORTB, 4	;Test bit 4
    goto Display4	;goto Display4 code
    
    BTFSC PORTB, 3	;Test bit 3
    goto Display3	;goto Display3 code
    
    BTFSC PORTB, 2	;Test bit 2
    goto Display2	;goto Display6 code
    
    BTFSC PORTB, 1	;Test bit 1
    goto Display1	;goto Display1 code
    
    BTFSC PORTB, 0	;Test bit 0
    goto Display0	;goto Display0 code
    
    goto DisplayDollar
    
    ;Display Code Here
    Display7:
	MOVLW 0x37
	MOVWF PORTC
	goto Main
	
    Display6:
	MOVLW 0x36
	MOVWF PORTC
	goto Main

    Display5:
	MOVLW 0x35
	MOVWF PORTC
	goto Main
	
    Display4:
	MOVLW 0x34
	MOVWF PORTC
	goto Main
	
    Display3:
	MOVLW 0x33
	MOVWF PORTC
	goto Main
	
    Display2:
	MOVLW 0x32
	MOVWF PORTC
	goto Main

    Display1:
	MOVLW 0x31
	MOVWF PORTC
	goto Main
	
    Display0:
	MOVLW 0x30
	MOVWF PORTC
	goto Main
	
    DisplayDollar:
	MOVLW 0x24
	MOVWF PORTC
	goto Main 