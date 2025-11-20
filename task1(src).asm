section .data    
    x: dd 0.5           
    n: dd 5       

section .bss 
    res: resd 1

section .text
    global main

main:
    movss xmm0, [x]         
    movss xmm1, xmm0        
    movss xmm2, xmm0       

    mov ecx, [n]      
    dec ecx                 
    mov eax, 1            
    movss xmm3, xmm0        
    mulss xmm3, xmm0    

loop_taylor:
    ; term = -term * x^2 / ((2n)*(2n+1))
       
    mulss xmm2, xmm3       

    ; (2n+2)*(2n+3)
    ;mov edx, eax
    lea edx, [eax*2 ]    
    ;mov ebx, eax
    lea ebx, [eax*2 + 1]    
    imul edx, ebx           
    cvtsi2ss xmm4, edx      
    divss xmm2, xmm4       
    test eax, 1
    jz add_term
    subss xmm1, xmm2
    jmp next
add_term:
    addss xmm1, xmm2

next:
    inc eax                 
    dec ecx                 
    jnz loop_taylor        

done:  
    movss [res], xmm1
    ret
