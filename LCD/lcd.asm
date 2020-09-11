.include "m328pdef.inc"

.def charReg    = r18  ; register that holds the current working character
.def dataReg    = r16 ; register that controls the 8 data lines to the LCD (PORTD)
.def selectReg  = r17 ; register that controls the R/W and RS lines (PORTB)

; initialize stack pointer
ldi r16, LOW(RAMEND)
out SPL, r16
ldi r16, HIGH(RAMEND)
out SPH, r16

; this program uses PORTD pins 0-7 to write to the LCD
; they are used as outputs so configure them as such
ldi r16, $FF  ; 1 = output so set all the pins to outputs
out DDRD, r16

; this sets the PORTB pins as well
ldi r16, $0C
out DDRB, r16

init_display:
    ldi r23, 10
    rcall delay10ms

    ldi selectReg, $00 ; all of the control lines are 0 for this
    ldi dataReg, $38   ; this command sets the display to 2 line mode with a 5-8 character font
    
    out PORTB, selectReg ; write the command to the LCD
    out PORTD, dataReg

    ldi r23, 1
    rcall delay10ms

    ldi dataReg, $0E ; turn on the display and cursor, control lines are unchanged so we don't need to modify the register

    out PORTD, dataReg

    ldi r23, 1
    rcall delay10ms

    ldi dataReg, $06 ; sets the display to move the character right after each character is written

    out PORTD, dataReg

    ldi r23, 1
    rcall delay10ms

    ldi dataReg, $01 ; should clear the display

    out PORTD, dataReg

    ldi r23, 1
    rcall delay10ms

    ldi charReg, $48 ; capital H
    rcall write_char

    ldi charReg, $65 ; lower case e
    rcall write_char

    ldi charReg, $6C ; lower case l
    rcall write_char

    ldi charReg, $6C ; lower case l
    rcall write_char

    ldi charReg, $6F ; lower case o
    rcall write_char

infinite_loop:
    nop
    rjmp infinite_loop

write_char:
    ldi selectReg, $08   ; set RS to 1 and keep R/W at 0
    mov dataReg, charReg ; copy the character to be written to the output register

    out DDRB, selectReg
    out DDRD, dataReg

    ldi r23, 1
    rcall delay10ms

    ret

.include "delay.inc"