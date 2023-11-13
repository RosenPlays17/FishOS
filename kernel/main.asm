org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
  jmp main

; Print a string to the screen
; Params:
;     - ds:si points to string
puts:
  ; save registers that will be modified
  push si
  push ax

.loop:
  lodsb              ; loads next character in al
  or al, al          ; verify if next character is null?
  jz .done

  mov ah, 0x0e       ; call bios interrupt
  mov bh, 0
  int 0x10

  jmp .loop

.done:
  pop ax
  pop si
  ret

main:
  ; setup data segments
  mov ax, 0
  mov ds, ax
  mov es, ax

  ; setup stack
  mov ss, ax
  mov sp, 0x7C00

  ; print message
  mov si, msg_among
  call puts

  hlt

.halt:
  jmp .halt

msg_among: db 'Among US', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
