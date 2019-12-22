# Reverse-Way
x86 Nasm Assembly

## How to run
Object file **file.o**
```bash
nasm -f elf file.asm
```
And create executable linked file
```bash
ld -m elf_i386 -s -o file file.o
```
And run
```bash
./file
```
