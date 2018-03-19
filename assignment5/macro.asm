;DOUBTS ... Does it matter if i use RAX or AX or EAX size of register matters ?
;and same for rsi or rdi does index register size affects the program
%macro read 2
  mov rax,0 ;opcode of accepting the input form the user
  mov rdi,0 ;
  mov rsi,%1 ;source index will point to the filename
  mov rdx,%2 ;size of accepting from user
  syscall
%endmacro

%macro print 2 ;Take two arguments where first is file name , second is file size
  mov rax,1 ;opcode of printing the output to the user
  mov rdx,%2 ;opcode to print STDOUT file
  mov rsi,%1 ;This will store the size of the file size
  mov rdi,1 ;This will point to the address of the file
  syscall
%endmacro

%macro fopen 1 ;take one argument where filename is taken ONLY
  mov rax,2 ; IDK
  mov rdx,0770o ;opcode for file is found !
  mov rsi,2 ;IDK
  mov rdi,%1;the file address is pointed by RDI
  syscall
%endmacro

%macro fread 3
  mov rax,0 ;Opcode to read
  mov rsi,%2
  mov rdi,%1
  mov rdx,%3 ;size of the file which will be passed as argument
  syscall
%endmacro

;We are not using the fwrite macro anywhere it is just for basic knowledge
%macro fwrite 3 ;where the first argument is destination , second arg is source
  mov ax,1 ;Opcode to write the
  mov dx,%3
  mov rdi,%1
  mov rsi,%2
  syscall
%endmacro

%macro fclose 1
  mov rax,3 ;opcode to exit the file
  mov rdi,%1;size for the procedure
  syscall
%endmacro

%macro exit 0
  mov ax,0
  mov rdi,0
  syscall
%endmacro
