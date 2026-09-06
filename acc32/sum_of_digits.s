.text
.org 0x00
_start:
    load_addr 0x80 
    store_addr n 
    bgez check_zero

    load_imm 0 
    sub n       
    store_addr n

check_zero:
    load_imm 0 
    store_addr sum 

loop:
    load_addr n 
    beqz finish

    rem ten
    store_addr rem_val

    load_addr sum 
    add rem_val
    store_addr sum 

    load_addr n
    div ten 
    store_addr n

    jmp loop

finish:
    load_addr sum
    store_addr 0x84
    halt

.data
.org 0x90
n:        .word 0
sum:      .word 0
ten:      .word 10
rem_val:  .word 0