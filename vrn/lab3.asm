%include "io64.inc"
section .rodata
    divisor: dq 1.247 
    fmt1: db "%d", 0
    fmt2: db "%d ", 0 

section .text
extern scanf
extern printf
extern malloc
extern free

global main

main:
    ; Пролог
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push rsi
    sub rsp, 8 + 32 + 8
    
    ; Выделение памяти
    mov rcx, 416 
    call malloc
    mov rsi, rax
    
    ; Ввод размера массива
    lea rcx, [fmt1]
    lea rdx, [rbp - 40]
    call scanf
    mov ebx, [rbp - 40] 
    xor r12d, r12d 
    
    ; Ввод элементов массива
cycle1_start:
    cmp r12d, ebx
    jge cycle1_end
    
    lea rcx, [fmt1]
    lea rdx, [rsi + r12 * 4]
    call scanf
    add r12, 1
    jmp cycle1_start

cycle1_end:
    mov r12, 0  
    mov r13d, `
    
    ; Вычисление начального gap
    mov eax, r13d
    cvtsi2sd xmm0, eax
    movsd xmm1, [divisor] 
    divsd xmm0, xmm1
    cvtsd2si r13, xmm0
    
    ; Сортировка Шелла
while_cycle_start:
    mov r9d, r13d
    cmp ebx, 1
    jl while_cycle_end

cycle2_start:
    cmp r9d, ebx
    jge cycle2_end
    
    mov r11d, r9d
    sub r11, r13
    mov eax, dword [rsi + r9 * 4]  
    cmp dword [rsi + r11 * 4], eax
    jle branch1
    
    ; Обмен элементов
    mov r8d, dword [rsi + r11 * 4]
    mov r10d, eax
    mov dword [rsi + r11 * 4], r10d
    mov dword [rsi + r9 * 4], r8d

branch1:
    add r9d, 1
    jmp cycle2_start

cycle2_end:
    ; Обновление gap
    mov eax, r13d
    cvtsi2sd xmm0, eax
    movsd xmm1, [divisor] 
    divsd xmm0, xmm1
    cvtsd2si r13, xmm0
    
    cmp r13d, eax
    jl gap_decreased
    dec r13
    cmp r13, 0
    jle while_cycle_end

gap_decreased:
    cmp r13, 1
    jge while_cycle_start 

while_cycle_end:
    mov r8d, 0 
    
    ; Вывод отсортированного массива
cycle3_start:
    cmp r12d, ebx
    jge cycle3_end
    
    lea rcx, [fmt2]
    mov edx, [rsi + r12 * 4]
    call printf
    add r12d, 1
    jmp cycle3_start

cycle3_end:
    ; Освобождение памяти и эпилог
    mov rcx, rsi
    call free 
    
    mov rsi, [rbp - 24]
    mov r13, [rbp - 16]
    mov r12, [rbp - 8]
    mov rbx, [rbp - 0]
    leave
    ret