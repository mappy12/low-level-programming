%include "io64.inc"

section .bss
    arr: resd 150
    
    
section .text
    global main
    
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    GET_DEC 4, eax
    mov dword [rbp-4], eax
    mov dword [rbp-8], 0
    
.loop_input:
    mov eax, [rbp-8]
    mov ecx, [rbp-4]
    cmp eax, ecx
    jge .loop_input_done
    
    GET_DEC 4, edx
    mov esi, [rbp-8]
    shl esi, 2
    lea rdi, [rel arr]
    add rdi, rsi
    mov [rdi], edx
    
    add dword [rbp-8], 1
    jmp .loop_input
    
.loop_input_done:
    mov eax, [rbp-4]
    mov [rbp-12], eax
    mov dword [rbp-16], 1
    PRINT_STRING "Original array: "
    mov ecx, [rbp-4]
    call print_arr
    NEWLINE
    NEWLINE
    
.main_loop:
    mov eax, [rbp-12]
    cmp eax, 1
    jg .comb_body
    mov eax, [rbp-16]
    cmp eax, 0
    jne .comb_body
    jmp .end_sort
    
.comb_body:
    mov eax, [rbp-12]
    imul eax, 10
    mov ecx, 13
    xor edx, edx
    div ecx
    cmp eax, 1
    jge .gap_ok
    mov eax, 1
    
.gap_ok:
    mov [rbp-12], eax
    mov dword [rbp-16], 0
    mov dword [rbp-20], 0
    jmp .inner_loop
    
.inner_loop:
    mov eax, [rbp-20]
    mov ecx, [rbp-4]
    mov edx, [rbp-12]
    
    sub ecx, edx
    cmp eax, ecx
    jl .inner_loop_body
    jmp .main_loop
    
.inner_loop_body:
    mov esi, [rbp-20]
    shl esi, 2
    lea rdi, [rel arr]
    add rdi, rsi
    mov eax, [rdi]
    
    mov ebx, [rbp-12]
    lea rdx, [rdi + rbx*4]
    mov ecx, [rdx]
    
    cmp eax, ecx
    jle .next_element
    
    mov [rdi], ecx
    mov [rdx], eax
    
    mov dword [rbp-16], 1
    
.next_element:
    add dword [rbp-20], 1
    jmp .inner_loop
    
.end_sort:
    PRINT_STRING "Sorted array: "
    mov ecx, [rbp-4]
    call print_arr
    NEWLINE
    
    mov rsp, rbp
    pop rbp
    ret
    
print_arr:
    mov r8d, 0
    
print_loop:
    cmp r8d, ecx
    jge print_done
    
    mov esi, r8d
    shl esi, 2
    lea rdi, [rel arr]
    add rdi, rsi
    mov eax, [rdi]
    PRINT_DEC 4, eax
    PRINT_STRING " "
    
    add r8d, 1
    jmp print_loop
    
print_done:
    ret