section .data
    S_struct:
        dq 0x0000000000000001
        dq 0x0000000000000001

section .text
    extern access6
    global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov ecx, 0x00010021    
    lea rdx, [S_struct]

    call access6

    add rsp, 32
    pop rbp
    ret