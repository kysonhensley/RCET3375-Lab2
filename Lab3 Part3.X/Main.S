;==============================================================================
; Name: Kyson Hensley
; Course: RCET 3375
; Semester: 5th semester
; Assignment: 
; Device:      PIC16F883
; Toolchain:   MPLAB X + pic-as
; Git URL:
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
    Count EQU 0x20		;register 20 for 8-bit counter
    midCount EQU 0x21		;register 21 for 8-bit counter
    inCount EQU 0x22		;register 22 for 8-bit counter
  
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
    BANKSEL ANSELH
    CLRF ANSELH
    BANKSEL PORTB
    CLRF PORTB
    CLRF PORTC
    BANKSEL TRISB
    CLRF TRISB			;config. PORTB as digital output
    CLRF TRISC			;config PORTC as digital output
    
    goto MainLoop

;------------------------------------------------------------------------------
; Main Loop
;------------------------------------------------------------------------------
MainLoop:
    ; add main loop code here
    MOVLW 0x01			;1 Tcy
    XORWF PORTB, 1		;1 Tcy
    MOVLW 0x0A
    MOVWF Count			;1 Tcy
    
OutterLoop:
    MOVLW 0x0A			;1 Tcy
    MOVWF midCount		;1 Tcy
    
MiddleLoop:
    MOVLW 0x0A			;1 Tcy
    MOVWF inCount
    
InnerLoop:
    DECFSZ inCount		;1(2) Tcy
    GOTO InnerLoop		;2 Tcy
    DECFSZ midCount		;1(2) Tcy
    goto MiddleLoop		;2 Tcy
    DECFSZ Count		;1(2) Tcy
    goto OutterLoop		;2 Tcy
    goto MainLoop		;2 Tcy
