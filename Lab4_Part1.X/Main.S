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
    delayTone        EQU 0x20
    buttonSelected   EQU 0x21
PSECT resetVect,class=CODE,delta=2
ResetVector:
    goto    Setup
PSECT code,class=CODE,delta=2
Setup:
    BANKSEL ANSELH
    CLRF    ANSELH
    BANKSEL TRISB
    MOVLW   0x02
    MOVWF   TRISB		;make bit 1 of portb input and all others outputs
    CLRF    TRISC		;make portc outputs
    BANKSEL PORTB
    CLRF    PORTC
    CLRF    buttonSelected	;button selection register
    GOTO    MainLoop
MainLoop:
    BTFSS   PORTB, 1
    ; skip NoButton if RB0 is 1 
    GOTO    NoButton
    MOVLW   0x01
    MOVWF   buttonSelected
    MOVLW   0x02                
    XORWF   PORTC, 1            ; toggle RC1 
    NOP
    MOVLW   0xA2
    MOVWF   delayTone
    CALL    ToneDelay
    GOTO    MainLoop
NoButton:
    CLRF    buttonSelected
    BCF     PORTC, 1            ; make RC1 low
    GOTO    MainLoop
ToneDelay:
    DECFSZ  delayTone, 1
    GOTO    ToneDelay
    RETURN