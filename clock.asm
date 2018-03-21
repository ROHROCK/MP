CODE SEGMENT
ASSUME CS:CODE

MAIN:
   jmp init

our_isr:
  push ax
  push bx
  push cx
  push dx
  push ds
  push ss
  push es
  push si
  push di
  push cs

  pop ds

  mov ax,0B800h
  mov es,ax
  mov bx,120
  mov ah,02h
  int 1AH

  mov al,ch
  call write_vram
  call col
  mov al,cl
  call write_vram
  call col
  mov al,dh
  call write_vram
  pop di
  pop si
  pop es
  pop ss
  pop di
  pop dx
  pop cx
  pop bx
  pop ax

  jmp cs:old_ptr

  write_vram proc

  mov ah,al
  and ah,0f0h
  mov dl,cl
  mov cl,04h
  ror ah,cl
  mov cl,dl
  add ah,30h
  mov es:[bx],ah
  inc bx
  mov ah ,00001100B
  mov es:[bx],ah
  inc bx

  mov ah,al
  mov ah,0fh
  add ah,30h
  mov es:[bx],ah
  inc bx
  ret

  write_vram endp

  col proc
    mov al,':'
    mov es[bx],al
    inc bx
    ret
  col endp

  old_ptr DD ?
  init:
    CLI
    push cs
    pop ds

    mov al,35h
    mov al,08h
    int 21h
    mov word old_ptr,bx
    mov word old_ptr+2,es

    mov al,25h ;set interupt vector
    mov al,08h
    lea dx,our_isr
    int 21h

    mov ah,31h
    mov al,1
    mov dx,offset init
    int 21h
    sti

    code ends

  end main
