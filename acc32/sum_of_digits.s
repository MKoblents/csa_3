    .text
    .org         0x00
_start:
    load         0x80
    store        n
    bgez         check_zero

    load_imm     0
    sub          n
    store        n

check_zero:
    load_imm     0
    store        sum

loop:
    load         n
    beqz         finish

    rem          ten
    add          sum

    store        sum

    load         n
    div          ten
    store        n

    jmp          loop

finish:
    load         sum
    store_addr   0x84
    halt

    .data
.org             0x90
n:               .word  0
sum:             .word  0
ten:             .word  10




    ;https://wrench.edu.swampbuds.me/report/add04520-0938-4fe4-9377-6d0bf2ddf8a1