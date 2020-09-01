.include "m328pdef.inc"

.equ innerLoopVal = 49998

.def maskReg    = r16
.def ledReg     = r17
.def outLoopCnt = r18
.def inLoopL    = r24 ; r24 and r25 are treated as a single 16 bit value for operations like sbiw and adiw
.def inLoopH    = r25

.cseg
.org 0x00

ldi r16, LOW(RAMEND)
out SPL, r16
ldi r16, HIGH(RAMEND)
out SPH, r16

clr ledReg
ldi maskReg, (1<<PIND2)
out DDRD, maskReg ; DDRD controls whether the pins associated with port D are inputs or outputs, 1 = output, 0 = input

start:
    eor ledReg, maskReg ; toggles the bit controlling the LED state
    out PORTD, ledReg    ; writes the bit to the port, PORTD controls the state of each pin if it is an output

    ldi outLoopCnt, 50   ; 50 * 10ms = 500 ms so 0.5 secs on, 0.5 secs off
    rcall delay10ms      ; call delay subroutine

    rjmp start           ; infinite loop

delay10ms: ; loads r24 and r25 as a 16 bit counter for the inner loop
    ldi inLoopL, LOW(innerLoopVal)
    ldi inLoopH, HIGH(innerLoopVal)

innerLoop:
    sbiw inLoopL, 1 ; stands for subtract immediate from word, second arg can be any value 0-63, only works on registers 24-31
    brne innerLoop  ; repeats the sbiw until the counter is 0

    dec outLoopCnt  ; we've completed a full iteration of the inner loop, so time to decrement the outer
    brne delay10ms  ; start over until outLoopCnt reaches 0

    nop             ; burns an extra clock cycle, stands for no operation, we need to do this because when brne branches, it takes one fewer clock cycle, so this adds one back

    ret             ; returns back to start