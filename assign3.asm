section .data
nline db 10,10
nline_len: equ $-nline
msg db 10,10,"MPL assignment 04: Hex to bcd and bcd to hex"
db 10,"--------------------------------------------------"
msg_len:equ $-msg

menu db 10,"------Menu--------"
db 10,"1.Hex to bcd"
db 10,"2.BCD to hex"
db 10,"3.Exit"
db 10
db 10,"Enter your choice:"
menu_len:equ $-menu

h2bmsg db 10,"Hex to BCD"
db 10,"Enter the 4-digit Hex number:"
h2bmsg_len:equ $-h2bmsg

b2hmsg db 10,"BCD to hex"
db 10,"Enter 5-digit BCD number: "
b2hmsg_len:equ $-b2hmsg

hmsg db 10,13,"equivalent Hex number is:"
hmsg_len:equ $-hmsg

bmsg db 10,13,"Equivalent BCD number is:"
bmsg_len:equ $-bmsg

section .bss
buf resb 6
buf_len: equ $-buf
digitcount resb 1
ans resw 1
char_ans resb 4

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro exit 0
print nline,nline_len
mov rax,60
xor rdi,rdi
syscall
%endmacro

section .text
global _start
_start:

print msg,msg_len
print menu,menu_len
read buf,2
mov al,[buf]

c1:
cmp al,'1'
jne c2
call hex_bcd
jmp _start

c2:
cmp al,'2'
jne c3
call bcd_hex
jmp _start

c3:
cmp al,'3'
exit

hex_bcd:
print h2bmsg,h2bmsg_len
call accept_16
mov ax,bx
mov rbx,10

back:
xor rdx,rdx
div rbx
push dx
inc byte[digitcount]
cmp rax,0
jne back
print bmsg,bmsg_len

print_bcd:
pop dx
add dl,30h
mov [char_ans],dl
print char_ans,1
dec byte[digitcount]
jnz print_bcd
ret

bcd_hex:
print b2hmsg,b2hmsg_len
read buf,buf_len
mov rsi,buf ;buf address to rsi
xor rax,rax ;clear rax reg
mov rbx,10 ;rbx = 10
mov rcx,05 ; rcx = 5

back1:
xor rdx,rdx ;this will clear the rdx reg
mul ebx ; AX * BX
mov dl,[rsi] ; dl will contain the lower 8 bytes
sub dl,30h ;sub 30 to ASCII -> HEX
add rax,rdx;add the result to rax
inc rsi ;to point to next digit
dec rcx ;dec the loop
jnz back1 ;jump to back1 when 0 is not encountered

mov [ans],ax ; save contents to ax reg as print procedure will be called
print bmsg,bmsg_len
mov ax,[ans]
call display_16
ret

accept_16:
read buf,5
xor bx,bx
mov rcx,4
mov rsi,buf

next_digit:
shl bx,04
mov al,[rsi]
cmp al,"0" ;If less then 0 ASCII range
jb error
cmp al,"9" ;If 0-9 Range
jbe sub30 ;substract 30 to bring it to decimal form
cmp al,"A" ;If It is Less than A range
jb error ;err
cmp al,"F" ;If it is less than F range
jbe sub37 ;subtract 37 to get A-F in memory
cmp al,"a" ;same logic as above just the ASC
jb error
cmp al,"f"
jbe sub57

error:
exit

sub57:
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
mov rsi,char_ans+3
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
;-----------------OUTPUT-----------------
;MPL assignment 04: Hex to bcd and bcd to hex
;--------------------------------------------------
;------Menu--------
;1.Hex to bcd
;2.BCD to hex
;3.Exit

;Enter your choice:1


;Hex to BCD
;Enter the 4-digit Hex number:FAB0

;Equivalent BCD number is:64176
;------Menu--------
;1.Hex to bcd
;2.BCD to hex
;3.Exit


;Enter your choice:2

;BCD to hex
;Enter 5-digit BCD number: 64176

;Equivalent BCD number is:FAB0
