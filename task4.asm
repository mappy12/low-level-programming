%include "io64.inc"

section .data
    x: dq 1.0
    y: dq 1.313
    a: dq 1.0
    tolerance: dq 0.0001  

section .text
    global main

main:
    fld qword [a]
    fmul qword [x]

    fld st0
    fldl2e
    fmul
    fld1
    fld st1
    fprem
    f2xm1
    fadd
    fscale
    fstp st1    

    fld qword [a]
    fmul qword [x]
    fchs
    fldl2e
    fmul
    fld1
    fld st1
    fprem
    f2xm1
    fadd
    fscale
    fstp st1   

    fld st1        
    fadd st0, st1  
    fld st2
    fsub st0, st2  
    fdivp st1, st0 

    fld qword [y]   
    fsub st0, st1  
    fabs   
    fld qword [tolerance] 
    fcomip st1
    ja equal       

    PRINT_STRING "true"
    jmp end_prog

equal:
    PRINT_STRING "false"

end_prog:
    fstp st0
    xor eax, eax
    ret
