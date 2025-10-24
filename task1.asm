%include "io64.inc"

section .rodata
    x: dd 2.0

    fact3: dd 6.0
    fact5: dd 120.0
    fact7: dd 5040.0
    fact9: dd 362880.0

section .bss
    result: resd 1

section .text
    global main
    extern printf

main:
    movss xmm0, [x]
    movss xmm1, xmm0

    movss xmm2, xmm0
    mulss xmm2, xmm0          ; x^2

    movss xmm3, xmm2
    mulss xmm3, xmm0          ; x^3

    movss xmm4, xmm3
    divss xmm4, [fact3]
    subss xmm1, xmm4          ; - x^3/3!

    movss xmm4, xmm3
    mulss xmm4, xmm2          ; x^5
    divss xmm4, [fact5]
    addss xmm1, xmm4          ; + x^5/5!

    movss xmm4, xmm4
    mulss xmm4, xmm2          ; x^7
    divss xmm4, [fact7]
    subss xmm1, xmm4          ; - x^7/7!

    movss xmm4, xmm4
    mulss xmm4, xmm2          ; x^9
    divss xmm4, [fact9]
    addss xmm1, xmm4          ; + x^9/9!

    movss [result], xmm1

    ret