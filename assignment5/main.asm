extern subprogram ;to access the other asm filename

global filehandle,char,buf,abuf_len ;variables to be accessed by another file

%include "macro.asm"
;import the macro asm file where the macro is defined
section .data

filemsg db 10,"Enter file name for string operation: "
filemsg_len equ $-filemsg

charmsg db 10,"Enter character to search: "
charmsg_len equ $-charmsg

errmsg db 10,"ERROR in opening file !",10
errmsg_len equ $-errmsg

exitmsg db 10,"Exit from the program ",10,10
exitmsg_len equ $-exitmsg
;---------------MSG section done !-----

section .bss
;basic buf reserve
buf resb 4096 ; reserve 4 bytes in buffer
buf_len equ $-buf
;----filename reserve size
filename resb 50 ;reserve 50 bytes
char resb 2 ; reserve 2 bytes where (1 is actual char 1 in enter ASCII)
filehandle resq 1
abuf_len resq 1 ;reserve the actual size of the program

;-------------------RESERVE SECTION DONE !----------

section .text
global _start
_start: ;tell the compiler to to start the exectution from here
  print filemsg,filemsg_len
  read filename,50
  dec rax ;dec rax as enter ASCII should no be included
  mov byte[filename + rax],0 ;set EOF to the address
  print charmsg,charmsg_len
  read char,2; HERE

  fopen filename
  cmp rax,-1H ;if file not found
  jle Error ;When file is not opened
  mov [filehandle],rax ;store address of filehandler in filehandle var

  fread [filehandle],buf,buf_len
  mov [abuf_len],rax

  call subprogram
  jmp Exit

  Error: print errmsg,errmsg_len
  Exit: print exitmsg,exitmsg_len
  exit
