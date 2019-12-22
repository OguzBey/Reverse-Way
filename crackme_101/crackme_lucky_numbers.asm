SYS_WRITE   equ 4
SYS_READ    equ 3
SYS_EXIT    equ 1
STD_IN      equ 2
STD_OUT     equ 1

section .data
    first_number_text db 'Uğurlu Sayı: '
    len_first equ $ - first_number_text
    good_job_text db 'Tebrikler !', 0xa
    len_good_job equ $ - good_job_text
    sorry_text db 'Başaramadın :((', 0xa
    len_sorry equ $ - sorry_text

section .bss
    first_number resb 2

section .text
    global _start

_bad:
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, sorry_text
    mov edx, len_sorry
    int 0x80
    mov eax, SYS_EXIT
    int 0x80

_good:
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, good_job_text
    mov edx, len_good_job
    int 0x80
    mov eax, SYS_EXIT
    int 0x80

_start:
    ; write first message
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, first_number_text
    mov edx, len_first
    int 0x80
    ; read numbers
    mov eax, SYS_READ
    mov ebx, STD_IN
    mov ecx, first_number
    mov edx, 2
    int 0x80

    mov al, [first_number]
    sub al, '0'
    mov bl, [first_number + 1]
    sub bl, '0'

    adc al, bl
    daa
    add bl, '0'
    
    cmp al, 16h
    jne _bad

    cmp bl, 38h
    jne _bad
    
    cmp eax, eax
    je _good