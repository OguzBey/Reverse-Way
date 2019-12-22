SYS_WRITE   equ 4
SYS_READ    equ 3
SYS_EXIT    equ 1
STD_IN      equ 2
STD_OUT     equ 1

section .data
    msg1 db 'İlk Sayı: '
    msg1_len equ $ - msg1
    msg2 db 'İkinci Sayı: '
    msg2_len equ $ - msg2
    msg3 db 'Sonuç: '
    msg3_len equ $ - msg3
    msg4 db '-CARRRRYYYYYY-'
    msg4_len equ $ - msg4

section .bss
    number1 resb 4
    number2 resb 4
    char1 resb 2
    char2 resb 2
    total resb 6

section .text
    global _start


_set_zero:
    mov al, '0'
    ret

_birler:
    mov ecx, esi
    _birler_loop:
        mov al, [ebx + ecx]
        dec ecx
        cmp al, 30h
        jl _birler_loop
        ret

_onlar:
    call _birler
    cmp al, 30h
    jl _set_zero
    mov al, [ebx + ecx]
    cmp al, 30h
    jl _set_zero
    ret

_yuzler:
    call _onlar
    cmp al, 30h
    jl _set_zero
    dec ecx
    mov al, [ebx + ecx]
    cmp al, 30h
    jle _set_zero
    ret

_start:
    ; first message
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, msg1
    mov edx, msg1_len
    int 0x80
    ; get first number
    mov eax, SYS_READ
    mov ebx, STD_IN
    mov ecx, number1
    mov edx, 4
    int 0x80

    ; second message
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, msg2
    mov edx, msg2_len
    int 0x80
    ; get second number
    mov eax, SYS_READ
    mov ebx, STD_IN
    mov ecx, number2
    mov edx, 4
    int 0x80

    mov esi, 0
    _length_1:
        mov al, [number1 + esi]
        inc esi
        cmp al, 30h
        jge _length_1
        dec esi
    
    mov ebx, esi
    
    mov esi, 0
    _length_2:
        mov al, [number2 + esi]
        inc esi
        cmp al, 30h
        jge _length_2
        dec esi
    
    cmp esi, ebx
    jg _continue
    mov esi, ebx
    _continue:
        nop

    ; birler
    mov ebx, number1
    call _birler
    sub al, '0'
    mov dl, al
    mov ebx, number2
    call _birler
    sub al, '0'
    adc al, dl
    daa

    call _carry
    push ecx; save cl
    call _write  ; write birler

    ; onlar
    mov ebx, number1
    call _onlar
    sub al, '0'
    mov dl, al
    mov ebx, number2
    call _onlar
    sub al, '0'
    adc al, dl
    daa
    pop ecx; cl
    adc al, cl
    daa

    call _carry; set cl
    push ecx; save cl
    dec esi
    call _write  ; write onlar
    inc esi

    ; yuzler
    mov ebx, number1
    call _yuzler
    sub al, '0'
    mov dl, al
    mov ebx, number2
    call _yuzler
    sub al, '0'
    adc al, dl
    daa
    pop ecx; cl
    adc al, cl
    daa
    
    call _carry

    sub esi, 2
    call _write ; write yuzler
    dec esi; elde kalan için

    cmp cl, 0h
    je _finish
    add cl, '0'
    mov [total + esi], cl

    _finish:
        nop
    
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, total
    mov edx, 6
    int 0x80

    mov eax, SYS_EXIT
    int 0x80

_write:; totale yaz
    add al, '0'
    mov [total + esi], al
    ret

_carry:; 0x9'dan büyükse elde ve sayıyı set et
    xor ecx, ecx
    cmp al, 9h
    jg _set_carry
    mov cl, 0h
    ret
    _set_carry:
        mov cl, 1h
        sub al, 10h
        ret