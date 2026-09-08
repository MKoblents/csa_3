; brainfuck_interpreter.s for m68k
; Упрощенный интерпретатор Brainfuck

.text
.org 0x00

_start:
    link A6, -16
    movea.l code_buffer, A0
    movea.l data_memory, A1
    movea.l output_buffer, A2
    move.l A0, -4(A6)
    move.l A1, -8(A6)
    move.l A2, -12(A6)
    jsr interpret_bf
    unlk A6
    halt

interpret_bf:
    link A6, -8
    movea.l -4(A6), A0
    movea.l -8(A6), A1
    movea.l -12(A6), A2

bf_loop:
    move.b (A0), D0
    cmp.b 0, D0
    beq bf_done
    cmp.b 62, D0
    beq cmd_greater
    cmp.b 60, D0
    beq cmd_less
    cmp.b 43, D0
    beq cmd_plus
    cmp.b 45, D0
    beq cmd_minus
    cmp.b 46, D0
    beq cmd_dot
    add.l 1, A0
    jmp bf_loop

cmd_greater:
    add.l 4, A1
    add.l 1, A0
    jmp bf_loop

cmd_less:
    sub.l 4, A1
    add.l 1, A0
    jmp bf_loop

cmd_plus:
    move.l (A1), D1
    add.l 1, D1
    move.l D1, (A1)
    add.l 1, A0
    jmp bf_loop

cmd_minus:
    move.l (A1), D1
    sub.l 1, D1
    move.l D1, (A1)
    add.l 1, A0
    jmp bf_loop

cmd_dot:
    move.l (A1), D1
    and.l 255, D1
    move.b D1, (A2)+
    add.l 1, A0
    jmp bf_loop

bf_done:
    unlk A6
    rts

.data
.org 0x100
code_buffer:
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.org 0x200
data_memory:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.org 0x300
output_buffer:
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
