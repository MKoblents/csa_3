\ parity.s for f32a
\ Вычисление битовой четности числа

.text
.org 0x00

_start:
    @p 0x80
    parity
    !p 0x84
    halt

parity:
    a!
    0
parity_loop:
    a
    if parity_done
    a
    1 and
    if skip_xor
    1 xor
skip_xor:
    a
    2/
    a!
    parity_loop
parity_done:
    ;
\https://wrench.edu.swampbuds.me/report/1e7c4cac-c729-40d2-b1fc-0ce8d1e0f56d