%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

m1 db 'Enter two digit multiplicand',0xa
m1len equ $-m1

m2 db 'Enter two digit multiplier',0xa
m2len equ $-m2

m3 db 'Succesive addition is:',0xa
m3len equ $-m3

m4 db 'Add and shift is',0xa
m4len equ $-m4

menu db '*****menu*****',0xa
     db '1:Succesive additon',0xa
     db '2:Shift and add result',0xa
     db '3:Exit',0xa
menulen equ $-menu

section .bss
num resb 3
num1 resb 3
num2 resb 3
result resw 4
choice resb 2
disp_buff resb 8

section .text
global _start
_start:
menum:
scall 1,1,menu,menulen
scall 0,0,choice,2

cmp byte[choice],'1'
je add1

cmp byte[choice],'2'
je add2

cmp byte[choice],'3'
je exit

exit:
	mov rax,60
	mov rdi,0
	syscall


add1:
	scall 1,1,m1,m1len
	scall 0,0,num,3

	call convert
	mov [num1],bl

	scall 1,1,m2,m2len
	scall 0,0,num,3

	call convert
	xor rax,rax
	xor rcx,rcx
	mov al,[num1]

back:
	add rcx,rax
	dec bl
	jnz back


mov [result],rcx
scall 1,1,m3,m3len
mov bx,[result]
call disp2
jmp menum


add2:

	scall 1,1,m1,m1len
	scall 0,0,num,3

	call convert
	mov [num1],bl

	scall 1,1,m2,m2len
	scall 0,0,num,3

	call convert

	mov [num2],bl
	scall 1,1,m4,m4len

	xor rax,rax
	xor rbx,rbx
	xor rcx,rcx
	xor rdx,rdx

	mov dl,[num1]
	mov bl,[num2]
	mov rcx,8

	x1:
	shl ax,1
	rol bl,1
	jnc z
	add ax,dx
	z:
	loop x1
	mov bx,ax
	call disp2
	jmp menum

;-------------------
convert:
  mov bx,00h
  mov esi,num
  mov ecx,2
up:
  rol bx,4
  mov al,[esi]
  cmp al,39h
  jbe next
  sub al,07h
next:
  sub al,30h
  add bl,al
  inc esi
loop up
ret
;--------------------------------
disp2:
  mov ecx,4
  mov edi,disp_buff
up1:
  rol bx,4
  mov al,bl
  and al,0fh
  cmp al,09h
  jbe next1
  add al,07h
next1:
  add al,30h
  mov [edi],al
  inc edi
loop up1
  scall 1,1,disp_buff,4
ret
