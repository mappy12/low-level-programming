section .data
    align 16
    S_struct:
        dq 2              
        dd 8.0            
        dd 2.0
    positive: dq 1.0
    negative: dd -1          

section .text
    global main
    extern access6

main:
    sub rsp, 40h              
    
    lea rcx, [S_struct]  
    
    mov r8d, [negative]          
    mov rax, [positive] 
    movq xmm1, rax
    
    call access6
    
    add rsp, 40h
    ret