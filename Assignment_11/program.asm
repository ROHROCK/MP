;Write 80387 ALP to obtain : i) Mean , ii)Variance , iii) Standard Deviation
;also plot the histogram for data set

%include "macro.asm"

section .data
array dd 10.00,10.00,10.00,10.00,10.00
count dw 5
 ;defining the string to the var
 menu_msg db 10,"*****MENU*****",10
  db  10,"1.Mean"
  db  10,"2.Variance"
  db  10,"3.Standard Deviation"
  db  10,'**************',10
  db 10,'Enter your choice: '
 menu_msg_len equ $-menu_msg
 mean db  10,'Mean: '
 mean_len equ $-mean
 variance db 10,'Variance: '
 variance_len equ $-variance
 standard db 10,'Standard Deviation: '
 standard_len equ $-standard
 point db "."
 hdec dq 100

section .bss
  choice resb 2
  meanS  resd 1
  variance1 resd 1
  sdeviation1 resd 1
  resbuff rest 1
  temp resb 2

section .text
  global _start
  _start:

  main:
    write menu_msg,menu_msg_len ;to display the menu to the user
    read choice,2 ;it will accept two char , one is choice and other is enter
    mov al,[choice]
  ;-------------------------SWITCH CASE STRUCTURE START---------------
    case1:
      cmp al,'1'
      jne case2
      ;CODE for case 1
      write mean,mean_len
      call meanFunction
      jmp main ;return to the main menu

    case2:
      cmp al,'2'
      jne case3
      ;CODE for case 2
      write variance,variance_len
      jmp main

    case3:
      cmp al,'3'
      jne case4
      ;Code for Case 3
      write standard,standard_len
      jmp main

    case4:
      cmp al,'4' ;does not matter if it checks as it is going to exit
      exit ;anything other than 1-3 it will terminate
    ;-------------------------SWITCH CASE STRUCTURE END---------------

 ;--------------------FUNCTION to find the MEAN -------------
  meanFunction:
    FINIT
    FLDZ
    mov rsi ,array
    mov rcx,5
    ;----CODE TO ADD the numbers--
    next:
      FADD dword[rsi] ;Add
      add rsi,4 ;incrmenting the pointer to the next value
      loop next
    ;-----ADDITION DONE
    FIDIV word[count] ;divide the ST0 with count ;variable Integer divide
    FST dword[meanS] ;store the answer in meanS ;Floating point store
    call disp_proc
  ret
;-----------------------FUNCTION END-------------------

;----------------FUNCTION TO DISPLAY----------------
  disp:
    mov rdi,temp
    mov rcx,02
    dispup1:
      rol bl,4 ;rotate left by 4 bytes
      mov dl,bl ; store it in dl
      and dl,0fh ;AND with 0fh why ? to clear upper bits maybe
      add dl,30h
      cmp dl,39h ; ASCII ?
      jbe dispskip1 ; jump if dl == 39h
      add dl,07h
      dispskip1:
        mov [rdi],dl
        inc rdi
        loop dispup1
      write temp,2 ;display the number

  ret ;return
;-----------------------FUNCTION END-------------------
;----------------FUNCTION TO DISPLAY----------------
  disp_proc:
  	FIMUL dword[hdec]
  	FBSTP tword[resbuff]
  	mov rsi,resbuff+9
  	mov rcx,09
    next1:
    	push rcx
    	push rsi

    	mov bl,[rsi]
    	call disp

    	pop rsi
    	pop rcx

     	dec rsi
      loop next1

    push rsi
    write point,1
    pop rsi
    mov bl,[rsi]
    call disp
  ret
;-----------------------FUNCTION END-------------------
  exit
