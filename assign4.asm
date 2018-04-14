section .data
nline db 10,10
nline_len equ $-nline
msg db 10,10,"MUL Assignment:"
db 10,"------"
msg_len equ $-msg
menu db 10,"-----Menu------"
db 10,"1.Successive addition method"
db 10,"2.Shift and add method"
db 10,"3.Exit"
db 10,"Enter your choice:"
menu_len  equ $-menu
n1msg db 10,"Enter two digit hex no1: "
n1msg_len equ $-n1msg
n2msg db 10,"Enter two dig hex no2: "
n2msg_len equ $-n2msg
resultSuccessive db 10,13,"Result of Successive addition is: "
resultSuccessive_len equ $-resultSuccessive
resultShift db 10,13,"Result of Shift and add is: "
resultShift_len equ $-resultShift_len
errmsg db 10,"Invalid data entered !"
errmsg_len equ $-errmsg

;Section to reserve space
buf resb 3
buf_len equ $-buf
no1 resb 1
no2 resb 1
ansl resb 1
ans resw 1
char_ans resb 4

%macro print 2
mov rax,1 ;opcode for printing the data
mov rdi,1 ; opcode to display at the terminal
mov rsi,%1 ;What is %
mov rdx,%2
syscall
%endmacro

%macro read 2
  mov rax,0
  mov rdi,0
  mov rsi,%1 ;why %1 ???
  mov rdi,%2
  syscall
%endmacro

%macro exit 0
mov rax,60 ;;why 60 ?
xor rdi,rdi ;clear the rdi register
syscall ;;call the system
%endmacro

section .text
  global _start
_start:
  print msg , msg_len
  print n1msg , n1msg_len
  call accept_16
  mov [no1],bx
  print n2msg , n2msg_len
  call accept_16
  mov [no2],bx

Disp_Menu:
  print menu ,menu_len
  read buf,2
  mov al,[buf]

c1:
  cmp al,'1'
  jne c2
  call SA
  jmp Disp_Menu
c2:
  cmp al,'3'
  jne err
  Exit
err:
  print errmsg,errmsg_len
  jmp Disp_Menu

SA:
  mov rbx,[no1] ;store the number in rbx reg
  mov rcx,[no2] ;number of times the loop should run
  xor rax,rax ;clear the rax reg
  xor rdx,rdx ;clear the rdx reg
back:
  add al,bl ;add the al and bl
  jnc next ;jump if not carry if true go to next label
  inc rdx ;inc rdx ONLY if carry is generated

next:
  dec rcx ;decrement the counter when carry is not generated
  jnz back
  mov [ansl],rax
  mov [ansh],rdx
  print resultShift,resultShift_len
  mov ax,[ansl]
  call display_16 ;call display_16 to adjust the ascii
  ret ;return to menu

SHA:
  mov rcx,08
  mov al,[no1]
  mov bl,[no2]

back1:
  shr bx,1 ;shift right
  jnc next1
  add [ans],ax ;add the ax contents with ans contents and store it at the answer itself
  shl ax,1

next1:
  dec rcx ; dec the counter
  jnz back1
  print resultShift,resultShift_len
  mov ax,[ans]
  call display_16
  ret

accept_16: ;label to adjust the ascii
  read buf,buf_len
  xor bx,bx ; clear the bx reg
  mov rcx,2 ;
  mov rsi,buf

next_digit: ;label to convert dig to ascii
  shl bx,04 ;
  mov al,[rsi]
  cmp al,"0"
  jb error
  cmp al,"9"
  jbe sub30
  cmp al,"A"
  jb error
  cmp al,"F"
  jbe sub37
  cmp al,"a"
  jb error
  cmp al,'f'
  jbe sub57

error:
  print errmsg ,errmsg_len
  exit

sub57 :
  sub al,20h

sub37:
  sub al,07h

sub30:
  sub al,30h
  add bx,ax
  inc rsi
  loop next_digit
  ret

display_16:
  mov rsi,char_ans+3 ;mov the pointer up to 3 places
  mov rcx,4

cnt:
  mov rdx,0
  mov rbx,16
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
