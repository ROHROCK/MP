# MP
ALP program
steps to execute asm program in this machine:
1st : nasm -f elf64 prog.asm
2nd: ld -i prog.o
3rd: gcc prog.o -o prog -nostdlib
4th: ./prog
