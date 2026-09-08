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
    0x7FFFFFFF and
    a!
    parity_loop
parity_done:
    ;

\https://wrench.edu.swampbuds.me/report/e0e61c8e-6e0d-4a60-9935-6a410e7a72a0