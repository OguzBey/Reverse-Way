section	.text
   global _start        ;must be declared for using gcc
	
_start:	                ;tell linker entry point
   mov ecx,10
	
l1:
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len_msg
    int 0x80

    pop ecx

    loop l1
    mov eax,1             ;system call number (sys_exit)
    int 0x80              ;call kernel
section	.bss
    num resb 1

section .data
    msg db 'Hello World !', 0xa
    len_msg equ $ - msg