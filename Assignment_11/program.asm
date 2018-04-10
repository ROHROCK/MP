;Write 80387 ALP to obtain : i) Mean , ii)Variance , iii) Standard Deviation
;also plot the histogram for data set

%include "macro.asm"

section .data
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

section .bss
  choice resb 2

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
  exit
