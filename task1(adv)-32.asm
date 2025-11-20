section .rodata
    fmt_in:         db "Enter x and n",10, 0
    fmt_scanf:      db "%f %d", 0
    fmt_out_input:  db "x = %f, n = %d",10, 0
    fmt_sin:        db "sin(x) = %f", 0

section .text
    global main
    extern printf
    extern scanf

main:
    push ebp
    mov  ebp, esp
    sub  esp, 32        

    push fmt_in
    call printf
    add  esp, 4

    lea eax, [ebp-4]       
    push eax
    lea eax, [ebp-8]     
    push eax
    push fmt_scanf
    call scanf
    add  esp, 12

    push dword [ebp-4]      

    fld dword [ebp-8]      
    sub esp, 8
    fstp qword [esp]        

    push fmt_out_input
    call printf
    add esp, 16

    fld dword [ebp-8]
    fst dword [ebp-12]      ; res = x
    fst dword [ebp-16]      ; term = x

    fld dword [ebp-8]
    fmul st0, st0
    fstp dword [ebp-20]     ; xsq = x*x

    mov eax, 1              ; k = 1
    mov ecx, [ebp-4]        ; n
    dec ecx
    js done


; ============================
; loop_taylor:
; ============================
loop_taylor:
    ;term = -term * x^2 / ((2n)*(2n+1))

    fld dword [ebp-16]      ; term
    fchs                    ; -term
    fmul dword [ebp-20]     ; -term * xsq

    mov edx, eax
    lea edx, [edx+edx]      ; 2k
    mov ebx, edx
    inc ebx                 ; 2k+1
    imul edx, ebx           ; denom = (2k)(2k+1)

    push edx
    fild dword [esp]        ; int → float
    add esp, 4

    fdivp st1, st0          ; st1 = st1 / st0

    fstp dword [ebp-16]     ; term = newTerm

    ; res += term
    fld dword [ebp-12]
    fadd dword [ebp-16]
    fstp dword [ebp-12]

    inc eax
    dec ecx
    jnz loop_taylor


done:
    fld dword [ebp-12]      ; result

    sub esp, 8
    fstp qword [esp]        ; double

    push fmt_sin
    call printf
    add  esp, 12

    leave
    ret
