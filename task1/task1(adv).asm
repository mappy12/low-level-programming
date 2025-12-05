section .rodata
    fmt_in: db "Enter x and n",10, 0
    fmt_scanf: db "%f %d", 0
    fmt_out_input: db "x = %f, n = %d",10, 0
    fmt_sin: db "sin(x) = %f", 0

section .text
    global main
    extern scanf
    extern printf
    
main:
    push rbp
    mov rbp, rsp
    sub rsp, 40
    
    ;printf("Enter x and n")
    lea rcx, [fmt_in]
    xor eax, eax
    call printf
    
    ; scanf("%f %d", &x, &n)
    lea rcx, [fmt_scanf]
    lea rdx, [rbp-8]
    lea r8, [rbp-4]
    xor eax, eax
    call scanf
    
    lea rcx, [fmt_out_input]
    movss xmm0, [rbp-8]          
    cvtss2sd xmm0, xmm0 
    movq rdx, xmm0   
    mov r8d, [rbp-4]
    xor eax, eax
    call printf
    
    movss xmm0, [rbp - 8]
    movss [rbp - 12], xmm0
    movss [rbp - 16], xmm0 
    mulss xmm0, xmm0
    movss [rbp - 20], xmm0
    
    mov eax, 1
    mov ecx, [rbp - 4]
    dec ecx
    js done
    
loop_taylor:
    ; term = -term * x^2 / ((2n)*(2n+1))
    
    movss xmm0, [rbp - 16]
    xorps xmm1, xmm1
    subss xmm1, xmm0
    
    mulss xmm1, [rbp - 20]
    
    lea edx, [rax + rax]     
    lea r8d, [rdx + 1] 
    imul edx, r8d
    
    cvtsi2ss xmm2, edx                        
    divss xmm1, xmm2
    
    movss [rbp - 16], xmm1
    
    movss xmm0, [rbp - 16]
    addss xmm0, [rbp - 12]            
    movss [rbp - 12], xmm0
    
    inc eax
    dec ecx
    jnz loop_taylor
    
done:
    lea rcx, [fmt_sin]
    movss xmm0, [rbp - 12]
    cvtss2sd xmm0, xmm0
    movq rdx, xmm0            
    call printf        
    
    leave
    ret