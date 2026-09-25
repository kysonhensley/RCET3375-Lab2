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
    delayTone       EQU 0x20
    buttonSelected  EQU 0x21
    innerCount	    EQU 0x22
PSECT resetVect,class=CODE,delta=2
ResetVector:
    goto    Setup
PSECT code,class=CODE,delta=2

Setup:
    BANKSEL ANSELH
    CLRF    ANSELH		;make PORTB pins Digital I/O
    BANKSEL TRISB
    MOVLW   0xFF
    MOVWF   TRISB		;make PORTB all inputs
    CLRF    TRISC		;make PORTC all outputs
    BANKSEL PORTB
    CLRF    PORTB		;Clear PORTB
    CLRF    PORTC		;Clear PORTC
    CLRF    buttonSelected	;Clear buttonSelected register
    GOTO    MainLoop		
    
MainLoop:
    ;Test keys
    BTFSC   PORTB, 7
    GOTO    Tone8
    BTFSC   PORTB, 6
    GOTO    Tone7
    BTFSC   PORTB, 5
    GOTO    Tone6
    BTFSC   PORTB, 4
    GOTO    Tone5
    BTFSC   PORTB, 3
    GOTO    Tone4
    BTFSC   PORTB, 2
    GOTO    Tone3
    BTFSC   PORTB, 1
    GOTO    Tone2
    BTFSC   PORTB, 0
    GOTO    Tone1
    BCF     PORTC, 0
    GOTO    MainLoop
    
Tone8:	    
    MOVLW   0x08		;Index 8
    GOTO    PlayTone
Tone7:	    
    MOVLW   0x07		;Index 7
    GOTO    PlayTone
Tone6:	    
    MOVLW   0x06		;Index 6
    GOTO    PlayTone
Tone5:	    
    MOVLW   0x05		;Index 5
    GOTO    PlayTone
Tone4:	    
    MOVLW   0x04		;Index 4
    GOTO    PlayTone
Tone3:	    
    MOVLW   0x03		;Index 3
    GOTO    PlayTone
Tone2:	    
    MOVLW   0x02		;Index 2
    GOTO    PlayTone
Tone1:	    
    MOVLW   0x01		;Index 1
    
PlayTone:
    MOVWF   buttonSelected	;store keys selected in GPR
    CALL    LookUpTone
    MOVWF   delayTone		;store index delay into delayTone register for delay
    MOVLW   0x01
    XORWF   PORTC, 1		;toggle bit 0 of PORTC
    CALL    ToneDelay		;Tone Delay for output frequency delay
    GOTO    MainLoop
    
LookUpTone:
    ADDWF   PCL, f		;skip W instructions from key test
    RETLW   0x00
    RETLW   0xEE
    RETLW   0xD4
    RETLW   0xBD
    RETLW   0xB2
    RETLW   0x9F
    RETLW   0x8E
    RETLW   0x7E
    RETLW   0x77
    
ToneDelay:
    MOVLW   0x04
    MOVWF   innerCount
InnerLoop:
    DECFSZ  innerCount, 1	;add 12uS to each ToneDelay loop for frequency accuracy
    GOTO    InnerLoop
    DECFSZ  delayTone, 1
    GOTO    ToneDelay
    RETURN