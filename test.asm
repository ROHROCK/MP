%include "macro.asm"
section .data
hellomsg db 10,"Hello: "
hellomsglen equ $-hellomsg

section .text
global _start
_start:
  print hellomsg,hellomsglen

  mov rbx, 0      ; return 0 status on exit - 'No Errors'
  mov rax, 1      ; invoke SYS_EXIT (kernel opcode 1)
  syscall
