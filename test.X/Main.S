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
;----------------------------------------------------
    
    
    
    
count    EQU 0x20                   ;use data memory address 0x20 as an 8-bit loop counter  

;------------------------------------------------------------------------------
; Main Loop
;------------------------------------------------------------------------------

MainLoop:
    MOVLW 0x01                      ;1 TCY code not part of delay
    XORWF PORTB,1                   ;1 TCY code not part of delay

    MOVLW 0x09                      ;1 TCY delay overhead
    MOVWF count                     ;1 TCY delay overhead
DelayLoop:                     
    DECFSZ count,1                  ;1(2) 1 TCY if not zero, 2 TCY if zero
    GOTO DelayLoop                  ;2 TCY

    GOTO   MainLoop                 ;2 TCY code not part of delay