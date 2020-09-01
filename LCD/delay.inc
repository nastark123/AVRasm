; this file can create delays in multiples of 10ms, and uses registers r23, r24, and r25

.def outerLoopCnt = r23
.def innerLoopL   = r24
.def innerLoopH   = r25

.equ innerLoopCnt = 49998 ; this is for a 20MHz frequency, can be calculated by the following formula: (frequency/400) - 2

delay10ms:
    ldi innerLoopL, LOW(innerLoopCnt)
    ldi innerLoopH, HIGH(innerLoopCnt)

innerLoop:
    sbiw innerLoopL, 1
    brne innerLoop

    dec outerLoopCnt
    brne delay10ms

    nop
    ret