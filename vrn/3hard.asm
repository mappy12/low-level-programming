section .data
    S_struct:
        dq 0x0000000370000007
        dq 0x0000034200000056

section .text
    extern access6
    global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov ecx, 0x00010010    
    
    
    lea rdx, [S_struct]

    call access6

    add rsp, 32
    pop rbp
    ret