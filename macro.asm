;All the macro needed such as printing and reading input from the user
%macro read 2 ;takes two parameters
  mov rax,0
  mov rdi,0
  mov rsi,%1 ;content to be accepted
  mov rdx,%2 ;accepted from the terminal
  syscall
%endmacro

;DOUBT WHAT DOES RDI REGISTER SPECIFY
%macro print 2 ;takes two parameters name and size
  mov rax,1 ;opcode for printing
  mov rdi,1 ;print at the terminal
  mov rsi,%1 ;memory address of the variable
  mov rdx,%2 ;the size of the message to be printed
  syscall
%endmacro
