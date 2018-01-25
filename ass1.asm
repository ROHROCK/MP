section .data #This section is used to initalize the variables
  msg db 10,'Count positive and negative numbers in an array',10
  msg_len equ $-msg

  pmsg db 10,'Count of positive numbers:'
  pmsg_len equ $-pmsg

  nmsg db 10,'Count of negative numbers:'
  nmsg_len equ $-nmsg

  nwline db 10h
  array dq 8505h,90ffh,87h,8a9fh,0adh,02h ;The array data in HEX values
  arrcnt equ 7 ; The
  pcnt db 0
  ncnt db 0

section .bss #This section is used to deinitalize the variables
  dispbuff resb 2

%macro print 2
  mov eax,4
  mov ebx,1
  mov ecx,%1
  mov edx,%2
  int 80h
%endmacro

section .text
global _start
_start:
        print msg,msg_len
         mov esi,array
         mov ecx,arrcnt

  up1:
    bt word[esi],31
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

  exit: ; code to exit the program
    mov eax,01
    mov ebx,0
    int 80h

  disp8num:
    mov ecx,2
    mov edi,dispbuff ;edi is displacment register which will store the dispbuff value

  dup1:
    rol bl,4 ;rol instruction will return the last nibble
    mov al,bl
    and al,0fh
    cmp al,09h
    jbe dskip ;jump if bytes are equal
    add al,07h ;add 07h to al register

  dskip:
    add al,30h
    mov [edi],al ; value of edi
    inc edi
    loop dup1

  print dispbuff,2
  ret
