.include "m328pdef.inc"

.def charReg   = r0  ; register that holds the current working character
.def modeReg   = r16 ; register that controls the states of the pins (input/output)
.def stateReg  = r17 ; register that controls whether the pins are high/low

; initialize stack pointer
ldi r16, LOW(RAMSTART)
out SPL, r16
ldi r16, HIGH(RAMSTART)
out SPH, r16

; this program uses PORTD pins 0-7 to write to the LCD
; they are used as outputs so configure them as such
clr r16
ldi r16, $FF  ; 1 = output so set all the pins to outputs
out DDRD, r16

start:
