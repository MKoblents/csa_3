.text
.org 0x0100

_start:
    movea.l 0x0FF0, A7
    jsr     main_interpreter
    halt

main_interpreter:
    link    A6, -8
    clr.l   -4(A6)
    
    move.l  0x500, D5
read_loop:
    cmp.l   0x540, D5
    bge     err_overflow
    movea.l 0x80, A4
    move.l  (A4), D0
    and.l   0xFF, D0
    cmp.l   10, D0
    beq     read_end
    movea.l D5, A1
    move.b  D0, (A1)
    add.l   1, D5
    jmp     read_loop
read_end:
    movea.l D5, A1
    clr.b   (A1)
    
    move.l  0x500, D4
    clr.l   D1
val_loop:
    movea.l D4, A2
    move.b  (A2), D0
    add.l   1, D4
    cmp.l   0, D0
    beq     val_end
    cmp.b   '[', D0
    bne     val_not_open
    add.l   1, D1
    jmp     val_loop
val_not_open:
    cmp.b   ']', D0
    bne     val_loop
    sub.l   1, D1
    blt     err_minus_one
    jmp     val_loop
val_end:
    cmp.l   0, D1
    bne     err_minus_one
    
    move.l  0x500, D4
    movea.l 0x600, A3
    clr.l   D3
exec_loop:
    movea.l D4, A2
    move.b  (A2), D0
    add.l   1, D4
    cmp.l   0, D0
    beq     exec_end
    
    cmp.b   '>', D0
    beq     cmd_right
    cmp.b   '<', D0
    beq     cmd_left
    cmp.b   '+', D0
    beq     cmd_plus
    cmp.b   '-', D0
    beq     cmd_minus
    cmp.b   '.', D0
    beq     cmd_dot
    cmp.b   ',', D0
    beq     cmd_comma
    cmp.b   '[', D0
    beq     cmd_open
    cmp.b   ']', D0
    beq     cmd_close
    cmp.b   ' ', D0
    beq     exec_loop
    cmp.b   9, D0
    beq     exec_loop
    cmp.b   10, D0
    beq     exec_loop
    cmp.b   13, D0
    beq     exec_loop
    jmp     err_minus_one
    
cmd_right:
    add.l   4, D3
    cmp.l   120, D3
    bge     err_minus_one
    jmp     exec_loop
    
cmd_left:
    sub.l   4, D3
    blt     err_minus_one
    jmp     exec_loop
    
cmd_plus:
    move.l  0(A3, D3), D1
    cmp.l   0x7FFFFFFF, D1
    beq     err_overflow
    add.l   1, D1
    move.l  D1, 0(A3, D3)
    jmp     exec_loop
    
cmd_minus:
    move.l  0(A3, D3), D1
    cmp.l   0x80000000, D1
    beq     err_overflow
    sub.l   1, D1
    move.l  D1, 0(A3, D3)
    jmp     exec_loop
    
cmd_dot:
    move.l  0(A3, D3), D0
    and.l   0xFF, D0
    movea.l 0x84, A4
    move.l  D0, (A4)
    jmp     exec_loop
    
cmd_comma:
    movea.l 0x80, A4
    move.l  (A4), D0
    and.l   0xFF, D0
    move.l  0(A3, D3), D1
    and.l   0xFFFFFF00, D1
    or.l    D0, D1
    move.l  D1, 0(A3, D3)
    jmp     exec_loop
    
cmd_open:
    move.l  0(A3, D3), D1
    cmp.l   0, D1
    bne     exec_loop
    move.l  1, D2
find_fwd:
    movea.l D4, A2
    move.b  (A2), D1
    cmp.l   0, D1
    beq     err_minus_one
    add.l   1, D4
    cmp.b   '[', D1
    bne     fwd_not_open
    add.l   1, D2
    jmp     fwd_check
fwd_not_open:
    cmp.b   ']', D1
    bne     fwd_check
    sub.l   1, D2
fwd_check:
    cmp.l   0, D2
    bne     find_fwd
    jmp     exec_loop
    
cmd_close:
    move.l  0(A3, D3), D1
    cmp.l   0, D1
    beq     exec_loop
    move.l  1, D2
    sub.l   2, D4
find_back:
    cmp.l   0x500, D4
    blt     err_minus_one
    movea.l D4, A2
    move.b  (A2), D1
    cmp.b   ']', D1
    bne     back_not_close
    add.l   1, D2
    jmp     back_check
back_not_close:
    cmp.b   '[', D1
    bne     back_check
    sub.l   1, D2
back_check:
    cmp.l   0, D2
    beq     find_back_done
    sub.l   1, D4
    jmp     find_back
find_back_done:
    jmp     exec_loop
    
exec_end:
    unlk    A6
    rts
    
err_minus_one:
    move.l  -1, D0
    movea.l 0x84, A4
    move.l  D0, (A4)
    halt
    
err_overflow:
    move.l  0xCCCCCCCC, D0
    movea.l 0x84, A4
    move.l  D0, (A4)
    halt

.data
.org 0x0600
bf_memory: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


;https://wrench.edu.swampbuds.me/report/d2bb1f88-22d6-42fd-acf6-84a67216d1c0