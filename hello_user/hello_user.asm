section .data
    hello_msg db '>> Hello stranger, what is your name ?', 0xa
    len_hello_1 equ $ - hello_msg
    text_user db '[?] '
    len_text equ $ - text_user
    resp_user db '>> Hello, '
    len_resp equ $ - resp_user

section .bss
    name resb 20

section .text
    global _start

_start:
    call _hello_stranger
    call _get_name
    call _hello_user

    mov eax, 1
    int 0x80

_hello_stranger:
    mov eax, 4
    mov ebx, 1
    mov ecx, hello_msg
    mov edx, len_hello_1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, text_user
    mov edx, len_text
    int 0x80
    ret

_get_name:
    mov eax, 3
    mov ebx, 2
    mov ecx, name
    mov edx, 20
    int 0x80
    ret

_hello_user:
    mov eax, 4
    mov ebx, 1
    mov ecx, resp_user
    mov edx, len_resp
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 20
    int 0x80
    ret
