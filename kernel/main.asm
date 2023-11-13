org 0x0
bits 16

%define ENDL 0x0D, 0x0A

start:
  ; print message
  mov si, msg_hello
  call puts
 
.halt:
  cli
  hlt

; Print a string to the screen
; Params:
;     - ds:si points to string
puts:
  ; save registers that will be modified
  push si
  push ax
  push bx

.loop:
  lodsb              ; loads next character in al
  or al, al          ; verify if next character is null?
  jz .done

  mov ah, 0x0E       ; call bios interrupt
  mov bh, 0
  int 0x10

  jmp .loop

.done:
  pop bx
  pop ax
  pop si
  ret

msg_hello: db 'Among US!!', ENDL, 0
