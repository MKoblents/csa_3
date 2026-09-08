
.data
.org 0x20
pos:            .word 0
error_flag:     .word 0


.text
.org 0x100

_start:
    lui  sp, %hi(0x800)
    addi sp, sp, %lo(0x800)
    
    jal  ra, proc_main

proc_main:
    addi sp, sp, -4
    sw   ra, 0(sp)

    addi t0, zero, 0x20
    sw   zero, 0(t0)
    sw   zero, 4(t0)

    jal  ra, proc_init_buffer

    jal  ra, proc_read_recursive

    addi t0, zero, 0x24
    lw   t1, 0(t0)
    bnez t1, cond_error

    addi t0, zero, 0x20
    lw   t1, 0(t0)
    sb   t1, 0(zero)
    
    jal  ra, proc_copy_to_output
    j    exit_main

cond_error:
    jal  ra, proc_fill_error

exit_main:
    lw   ra, 0(sp)
    addi sp, sp, 4
    halt

proc_init_buffer:
    addi sp, sp, -4
    sw   ra, 0(sp)

    addi t0, zero, 0x00
    addi t1, zero, 0x5F
    addi t2, zero, 32

loop_init:
    beqz t2, exit_init
    sb   t1, 0(t0)
    addi t0, t0, 1
    addi t2, t2, -1
    j    loop_init

exit_init:
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra
    
proc_read_recursive:
    addi sp, sp, -12
    sw   ra, 8(sp)
    sw   s0, 4(sp)
    sw   s1, 0(sp)

    addi t0, zero, 0x80
    lb   t1, 0(t0)

    addi t2, zero, 0x0A
    beq  t1, t2, exit_read
    
    addi t0, zero, 0x20
    lw   t2, 0(t0)
    
    slti t3, t2, 31
    beqz t3, cond_overflow

    mv   a0, t1
    jal  ra, proc_to_lower
    mv   t1, a0
    
    addi t0, zero, 0x00
    add  t0, t0, t2
    addi t0, t0, 1
    sb   t1, 0(t0)

    addi t2, t2, 1
    addi t0, zero, 0x20
    sw   t2, 0(t0)

    jal  ra, proc_read_recursive

exit_read:
    lw   ra, 8(sp)
    lw   s0, 4(sp)
    lw   s1, 0(sp)
    addi sp, sp, 12
    jr   ra

cond_overflow:
    addi t0, zero, 0x24
    addi t1, zero, 1
    sw   t1, 0(t0)
    j    exit_read


proc_to_lower:
    addi sp, sp, -4
    sw   ra, 0(sp)

    addi t0, zero, 0x41
    addi t1, zero, 0x5A

    bgt  t0, a0, exit_to_lower

    bgt  a0, t1, exit_to_lower

    addi a0, a0, 0x20

exit_to_lower:
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra


proc_copy_to_output:
    addi sp, sp, -4
    sw   ra, 0(sp)

    addi t0, zero, 0x20
    lw   t2, 0(t0)

    beqz t2, exit_copy

    addi t0, zero, 0x01
    addi t1, zero, 0x84
    
loop_copy:
    beqz t2, exit_copy
    lb   t3, 0(t0)
    sb   t3, 0(t1)
    addi t0, t0, 1
    addi t2, t2, -1
    j    loop_copy

exit_copy:
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra

proc_fill_error:
    addi sp, sp, -4
    sw   ra, 0(sp)

    addi t0, zero, 0x00
    addi t1, zero, 0xCC
    addi t2, zero, 32

loop_error_buf:
    beqz t2, exit_error_buf
    sb   t1, 0(t0)
    addi t0, t0, 1
    addi t2, t2, -1
    j    loop_error_buf

exit_error_buf:
    addi t0, zero, 0x84
    lui  t1, %hi(0xCCCCCCCC)
    addi t1, t1, %lo(0xCCCCCCCC)
    sw   t1, 0(t0)

exit_error:
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr   ra