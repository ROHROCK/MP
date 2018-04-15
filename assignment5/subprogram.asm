;------data section -------
section .data
smsg db 10,"Number of character: ",10
smsg_len equ $-smsg

linemsg db 10,"Number of lines in the file: ",10
linemsg_len equ $-linemsg

charmsg db 10,"Number of character in the file: ",10
charmsg_len equ $-charmsg

section .bss
scount resq 1 ; reserve 8 bytes
linecount resq 1;same
charcount resq 1 ;same

char_ans resb 16  ;reserve 16 bytes

global subprogram ;GLOBAL declared !
extern filehandle,char,buf,abuf_len

%include "macro.asm"

;-----CODE SECTION-----
section .text
global _main
_main:

subprogram: ;procedure defined
  xor rax,rax ;------------_CLEAR all the reg ---------------
  xor rbx,rbx
  xor rcx,rcx
  xor rsi,rsi

  mov bl,[char]
  mov rsi,buf
  mov rcx,[abuf_len] ;store the actual length of the file in CX

again:
  mov al,[rsi] ;mov contents of RSI char in the file

case_s :
  cmp al,20h
  jne case_n
  inc qword[scount]
  jmp next

case_n :
  cmp al,0Ah
  jne case_c
  inc qword[linecount]
  jmp next

case_c:
  cmp al,bl
  jne next
  inc qword[charcount]

next:
  inc rsi
  dec rcx
  jnz again

;space print
print smsg,smsg_len
mov rax,[scount]
call display

;print line
print linemsg,linemsg_len
mov rax,[linecount]
call display

;print char
print charmsg,charmsg_len
mov rax,[charcount]
call display

fclose [filehandle] ;close the file
ret ;POP CS:IP

display:
	mov  rsi,char_ans+3
	mov  rcx,4

cnt:
  mov  rdx,0
	mov  rbx,10
	div rbx
	cmp dl,09h
	jbe add30
	add dl,07h

add30:
	add dl,30h
	mov [rsi],dl
	dec rsi
	dec rcx
	jnz cnt

	print char_ans,4
ret
