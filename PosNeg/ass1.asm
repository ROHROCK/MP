;Write x86/x64 ALP to count number of postive and negative numbers from the array
%include "macro.asm"
section .data
  pmsg db 10,'Count of positive numbers:'
  pmsg_len equ $-pmsg
  nmsg db 10,'Count of negative numbers:'
  nmsg_len equ $-nmsg
  nwline db 10
  array dw 0h,0h,0h,0h,0h,0h,9FFFh ;The array data in HEX values
  arrcnt equ 7
  pcnt db 0
  ncnt db 0

section .bss ;This section is used to deinitalize the variables
  dispbuff resb 2

section .text
global _start
_start:
    mov esi,array
    mov ecx,arrcnt
  up1:
    bt word[esi],31 ;bit test
    jnc pnxt
    inc byte[ncnt]
    jmp pskip

  pnxt:
    inc byte[pcnt]

  pskip:
    inc esi
    inc esi
    loop up1
  print pmsg,pmsg_len
  mov bl,[pcnt]
  call disp8num
  print nmsg,nmsg_len
  mov bl,[ncnt]
  call disp8num
  print nwline,1
  exit

  disp8num:
    mov ecx,2
    mov edi,dispbuff ;edi is displacment register which will store the dispbuff value
  dup1:
    rol bl,4 ;rol instruction will return the last nibble
    mov al,bl
    and al,0fh ;MASK the upper bits
    cmp al,09h ;compare
    jbe dskip ;jump if bytes are less than or equal
    add al,07h ;add 07h to al register since it is character
  dskip:
    add al,30h
    mov [edi],al ; value of edi
    inc edi
    loop dup1
  print dispbuff,2
  ret
