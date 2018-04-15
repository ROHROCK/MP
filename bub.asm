%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro


section .data
title db 10,13,"**BUBBLe sort***" 
title_len equ $-title
openmsg db 10,13,"File opened successfully" 
openmsg_len equ $-openmsg

closemsg db 10,13,"File closed successfully" 
closemsg_len equ $-closemsg

errmsg db 10,13,"Failed to open file" 
errmsg_len equ $-errmsg

sortmsg db 10,13,"File sorted successfully"
sortmsg_len equ $-sortmsg

f1name db 'file1.txt',0


section .bss
buffer resb 200
buffercpy resb 200
bufferlen resb 8
cnt1 resb 8
cnt2 resb 8
fdis resb 8


section .text
global _start
_start:
scall 1,1,title,title_len
scall 2,f1name,2,777

mov qword[fdis],rax
bt rax,63
jc error
scall 1,1,openmsg,openmsg_len
jmp next1

error:
	scall 1,1,errmsg,errmsg_len
	jmp exit

next1:
	scall 0,[fdis],buffer,200
	mov qword[bufferlen],rax
	mov qword[cnt1],rax
	mov qword[cnt2],rax

bubble:

	mov al,byte[cnt2]
	mov byte[cnt1],al
	dec byte[cnt1]
	mov rsi,buffer
	mov rdi,buffer+1

loop:
	mov bl,byte[rsi]
	mov cl,byte[rdi]
	cmp bl,cl
	ja swap
	inc rsi
	inc rdi
	dec byte[cnt1]
	jnz loop
	dec byte[bufferlen]
	jnz bubble
	jmp end
	

swap:
	mov byte[rsi],cl
	mov byte[rdi],bl
	inc rsi
	inc rdi
	dec byte[cnt1]
	jnz loop
	dec byte[bufferlen]
	jnz bubble

end:
	scall 1,1,sortmsg,sortmsg_len
	scall 1,1,buffer,qword[cnt2]
	scall 1,qword[fdis],sortmsg,sortmsg_len
	scall 1,qword[fdis],buffer,qword[cnt2]

	mov rax,3
	mov rdi,f1name
	syscall
exit:
	mov rax,60
	mov rdi,0
	syscall
		
