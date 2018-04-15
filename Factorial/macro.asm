;Macro for reading from the terminal 
%macro read 2
  mov ax,0
  mov si,%1
  mov di,%2
  mov dx,0
syscall
%endmacro

;Macro for display to the terminal
%macro display 2
  mov ax,1
  mov si,%1
  mov di,%2
  mov dx,0
  syscall
%endmacro
