section .data
    a: dd 8.0
    b: dd -1.0

section .text
    global main
    
main:
    fld1
    fld dword[a]
    fyl2x  
    fld dword[b]
    fadd
    fld1
    fpatan
    fstp st0
    ret
