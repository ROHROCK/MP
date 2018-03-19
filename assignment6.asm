;code for real mode to protected mode
;---------------- Data section --------------
section .data ;msg for printing and db stores 1 bytes
  msg1: db "Sorry, processor is in the REAL mode ",10
  msg1len equ $-msg1
  msg2: db 10,"Entered PROTECTED mode"
  msg2len: equ $-msg2
  msg3: db 10,"Content of GDTR"
  msg3len: equ $-msg3
  msg4: db 10,"Content of IDTR"
  msg4len: equ $-msg4
  msg5: db 10,"Content of LDTR"
  msg5len: equ $-msg5
  msg6: db ":"
  msg6len: equ $-msg6
;---------------------- BSS section--------
section .bss
GDTR resw 1 ;resw will reserve word allocates 2 bytes
LDTR resw 3 ;2 x 3
IDTR resw 3 ;2 x 3
MSW resw 1 ;2 x 1
result resb 4 ;resb will reserve 1 byte so 1 x 4 bytes

;macro for printing on the terminal
%macro print 2
  mov rax,1 ;printing code store in rax
  mov rdi,1
  mov rsi,%1 ;what to print
  mov rdx,%2 ;number of bytes to print
  syscall
%endmacro

section .text
  global _start
  _start:
     SMSW eax ;SMSW - store machine status word
     BT eax,0 ; BT - bit test , eax 3rd LSB from eax to CF
     JC protmode ; Jump to protmode function if carry is 0
     print msg1,msg1len ;print the "Real msg"

     jmp exit

    ;protmode function
    protmode:
      print msg2,msg2len
      SGDT [GDTR] ;SGDT : store global/Interrupt DT
      SLDT [LDTR] ;SLDT : store Local DT
      SIDT [IDTR] ;SIDT : store Interrupt DT
      SMSW [MSW] ;SMSW : store Most Significant Word

    print msg3,msg3len
    mov bx,[GDTR+4]
    call display
    mov bx,[GDTR+2]
    call display
    print msg6,msg6len
    mov bx,[GDTR]
    call display

    print  msg4,msg4len
    mov bx,[IDTR+4]
    call display
    mov bx,[IDTR+2]
    call display
    print msg6,msg6len
    mov bx,[IDTR]
    call display

    mov bx,[LDTR]
    call display
    print msg5,msg5len

    mov bx,[MSW]
    call display

    exit:
      mov rax , 60
      mov rbx,0
      syscall

    display:
      mov rdi,result
      mov rcx,4

    l1:
      rol bx,4 ; rotate left bs reg by 4 times
      mov dl,bl ; content of bl to dl
      and dl,0fh ; and operation on dl with 0fh ASCII adjusment
      cmp dl,09h ; compare dl with 9h
      jbe l2 ; jump to l2 if below and equal
      add dl,07h ; correct the number if > 9

    l2:
      add dl,30h
      mov [rdi],dl
      inc rdi
      loop l1

    print result,4
    ret
