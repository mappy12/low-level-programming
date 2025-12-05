section .data
    align 16
    struc_data:
        dq 2              ; [rcx] - qword (целое число)
        dd 6.0            ; [rcx+8] - float (будет делиться)
        dd 3.0            ; [rcx+0Ch] - float (должен равняться результату деления)

section .text
    global main
    extern access6

main:
    sub rsp, 40h                 ; Больше места для выравнивания
    
    ; Проверяем условие: 6.0 / 2 = 3.0
    ; И 3.0 после int->float преобразования остается 3.0
    
    lea rcx, [struc_data]        ; rcx = указатель на структуру
    
    mov r8d, 0xBF800000          ; -1.0 как целое (отрицательное)
    
    mov rax, 0x3FF0000000000000  ; +1.0 как double
    movq xmm1, rax
    
    call access6
    
    add rsp, 40h
    ret