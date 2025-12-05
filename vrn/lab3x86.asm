section .data
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
    push ebp
    mov ebp, esp
    sub esp, 40 ; место для локальных переменных
    
    ; Локальные переменные:
    ; [ebp-4] = array_size
    ; [ebp-8] = temp
    ; [ebp-12] = temp2
    ; [ebp-16] = ind
    ; [ebp-20] = gap
    ; [ebp-24] = i
    ; [ebp-28] = j
    ; [ebp-32] = masi
    
    ; Ввод array_size
    lea eax, [ebp-4]
    push eax
    push  fmt1
    call scanf
    add esp, 8
    
    ; Выделение памяти для массива
    mov eax, [ebp -4]
    imul eax, 4
    push eax
    call malloc    
    add esp, 4
    mov [ebp-32], eax
    
    
    mov dword [ebp - 24], 0 ; i = 0
    ; Инициализация массива
    cycle1_start:
        mov esi, [ebp-32] 
        mov eax, [ebp - 4]
        cmp [ebp - 24], eax
        jge cycle1_end
    
        lea eax, [ebp - 8]
        push eax
        push fmt1
        call scanf
        add esp, 8
        
        mov esi, [ebp - 32]
        mov eax, [ebp - 24]
        mov edx, [ebp - 8]
        mov dword [esi + eax *4], edx
        
        mov eax, [ebp - 24]
        add eax, 1
        mov [ebp - 24], eax
        jmp cycle1_start
        
    cycle1_end: 
        mov eax, [ebp - 4]
        ; Вычисление начального gap
        mov [ebp - 20], eax
        cvtsi2sd xmm0, eax
        movsd xmm1, [divisor] 
        divsd xmm0, xmm1
        cvtsd2si eax, xmm0
        mov [ebp - 20], eax
        
    while_cycle_start:
        mov eax, [ebp - 20]
        mov [ebp - 28], eax
        cmp dword [ebp - 20], 1
        jl while_cycle_end
        
    cycle2_start:
        mov eax, [ebp - 28]
        cmp eax, [ebp - 4]
        jge cycle2_end
    
        mov [ebp-16], eax
        mov eax, [ebp - 20]
        sub dword [ebp-16], eax
        mov ecx, [ebp-28]        ; загружаем индекс j
        mov eax, [esi + ecx * 4] ; array[j]
        mov edx, [ebp-16]        ; загружаем индекс ind  
        cmp dword [esi + edx * 4], eax ; array[ind] сравнить с array[j]
        jle branch1
    
        ; Обмен элементов
        mov eax, dword [esi + edx * 4]
        mov ebx, dword [esi + ecx * 4]
        mov dword [esi + ecx * 4], eax
        mov dword [esi + edx * 4], ebx
        
     branch1:
        mov eax, [ebp - 28]
        add eax, 1
        mov [ebp - 28], eax
        jmp cycle2_start
     
     cycle2_end:
        ; Обновление gap
        mov eax, [ebp - 20]
        cvtsi2sd xmm0, eax
        movsd xmm1, [divisor] 
        divsd xmm0, xmm1
        cvtsd2si eax, xmm0
        mov [ebp - 20], eax
    
        cmp dword [ebp - 20], eax
        jl gap_decreased
        dec dword [ebp - 20]
        cmp dword [ebp - 20], 0
        jle while_cycle_end
        
     gap_decreased:
        cmp dword [ebp - 20], 1
        jge while_cycle_start 
     
     while_cycle_end:
        mov dword [ebp - 24], 0
     
     cycle3_start:
        mov edx, [ebp - 24]
        cmp edx, [ebp - 4]
        jge cycle3_end
    
        mov eax, dword [esi + edx *4]
        push eax
        push fmt2
        call printf
        add esp, 8
        mov eax, [ebp - 24]
        add eax, 1
        mov [ebp - 24], eax
        jmp cycle3_start
    cycle3_end:
        ; Освобождение памяти
        push dword [ebp-32]
        call free
        add esp, 4
    
        leave
        ret















    