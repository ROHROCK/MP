%macro write 2
  mov rax ,1
  mov rdi ,1
  mov rsi,%1
  mov rdx,%2
  syscall
%endmacro
%macro read 2
  mov rax ,0
  mov rdi ,0
  mov rsi,%1
  mov rdx,%2
  syscall
%endmacro

%macro exit 0
  mov rax ,60
  xor rdi ,rdi
  syscall
%endmacro
