.text
_start:
    movea.l 0x1000, A7
    move.l  0x200, D5
    move.l  0, D7
loop:
    move.l  0x80, D0
    add.l   D7, D0
    movea.l D0, A0
    move.b  (A0), D0
    add.l   1, D7
    beq     done
    cmp.b   62, D0
    beq     right
    cmp.b   60, D0
    beq     left
    cmp.b   43, D0
    beq     plus
    cmp.b   45, D0
    beq     minus
    cmp.b   46, D0
    beq     dot
    cmp.b   44, D0
    beq     comma
    cmp.b   91, D0
    beq     open
    cmp.b   93, D0
    beq     close
    jmp     loop
right:
    add.l   4, D5
    jmp     loop
left:
    sub.l   4, D5
    jmp     loop
plus:
    movea.l D5, A0
    add.l   1, (A0)
    jmp     loop
minus:
    movea.l D5, A0
    sub.l   1, (A0)
    jmp     loop
dot:
    movea.l D5, A0
    move.b  (A0), D0
    movea.l 0x84, A1
    move.b  D0, (A1)
    jmp     loop
comma:
    movea.l 0x80, A0
    move.b  (A0), D2
    movea.l D5, A0
    move.l  (A0), D1
    lsr.l   8, D1
    lsl.l   8, D1
    or.b    D2, D1
    move.l  D1, (A0)
    jmp     loop
open:
    movea.l D5, A0
    move.l  (A0), D0
    bne     loop
    move.l  1, D1
open_lp:
    move.l  0x80, D0
    add.l   D7, D0
    movea.l D0, A0
    move.b  (A0), D0
    add.l   1, D7
    cmp.b   91, D0
    bne     open_ck
    add.l   1, D1
    jmp     open_lp
open_ck:
    cmp.b   93, D0
    bne     open_lp
    sub.l   1, D1
    bne     open_lp
    jmp     loop
close:
    movea.l D5, A0
    move.l  (A0), D0
    beq     loop
    move.l  1, D1
close_lp:
    sub.l   1, D7
    move.l  0x80, D0
    add.l   D7, D0
    movea.l D0, A0
    move.b  (A0), D0
    cmp.b   93, D0
    bne     close_ck
    add.l   1, D1
    jmp     close_lp
close_ck:
    cmp.b   91, D0
    bne     close_lp
    sub.l   1, D1
    bne     close_lp
    add.l   1, D7
    jmp     loop
done:
    halt