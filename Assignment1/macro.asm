%macro print 2
  mov rax,1
  mov rdi,1
  mov rsi,%1
  mov rdx,%2
  syscall
%endmacro

%macro exit 0 ; code to exit the program
  mov rax,60
  mov rbx,0
  syscall
%endmacro
