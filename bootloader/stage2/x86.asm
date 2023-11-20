%macro x86_EnterRealMode 0
  [bits 32]
  jmp word 18h:.pmode16

.pmode16:
  [bits 16]
  ; disable protected mode bit in cr0
  mov eax, cr0
  and al, ~1
  mov cr0, eax

  ; jump to real mode
  jmp word 00h:.rmode

.rmode:
  ; setup segments
  mov ax, 0
  mov ds, ax
  mov ss, ax

  ; enable interrupts
  sti
%endmacro

%macro x86_EnterProtectedMode 0
  cli

  ; set protection enable flag in cr0
  mov eax, cr0
  or al, 1
  mov cr0, eax

  ; far jump into protected mode
  jmp dword 08h:.pmode

.pmode:
  [bits 32]

  ; setup segment registers
  mov ax, 0x10
  mov ds, ax
  mov ss, ax
%endmacro

%macro LinearToSegOffset 4
; Convert linear address to segment:offset address
; Args:
;     1 - linear address
;     2 - (out) target segment (e.g. es)
;     3 - target 32-bit register to use (e.g. eax)
;     4 - target lower 16-bit half of #3 (e.g. ax)

  mov %3, %1                        ; linear address to eax
  shr %3, 4
  mov %2, %4
  mov %3, %1
  and %3, 0xf
%endmacro

global x86_outb
x86_outb:
  [bits 32]
  mov dx, [esp + 4]
  mov al, [esp + 8]
  out dx, al
  ret

global x86_inb
x86_inb:
  [bits 32]
  mov dx, [esp + 4]
  xor eax, eax
  in al, dx
  ret

global x86_Disk_GetDriveParams
x86_Disk_GetDriveParams:
  [bits 32]
  ; make new call frame
  push ebp                          ; save old call frame
  mov ebp, esp                      ; initialize new call frame

  x86_EnterRealMode
  [bits 16]

  ; save regs
  push es
  push bx
  push si
  push di

  ; call interrupt
  mov dl, [bp + 8]                  ; dl - disk drive
  mov ah, 08h
  mov di, 0
  mov es, di
  stc
  int 13h

  ; out params
  mov eax, 1
  sbb eax, 0

  ; drive type from bl
  LinearToSegOffset [bp + 12], es, esi, si
  mov es:[si], bl

  ; cylinders
  mov bl, ch                        ; cylinders - lower bits in ch
  mov bh, cl                        ; cylinders - upper bits in cl (6-7)
  shr bh, 6
  inc bx
  LinearToSegOffset [bp + 16], es, esi, si
  mov es:[si], bx

  ; sectors
  xor ch, ch                        ; sectors - lower 5 bits in cl
  and cl, 3Fh
  LinearToSegOffset [bp + 20], es, esi, si
  mov es:[si], cx

  ; heads
  mov cl, dh                        ; heads - dh
  inc cx
  LinearToSegOffset [bp + 24], es, esi, si
  mov es:[si], cx

  ; restore regs
  pop di
  pop si
  pop bx
  pop es

  ; return
  push eax

  x86_EnterProtectedMode
  [bits 32]

  pop eax

  ; restore old call frame
  mov esp, ebp
  pop ebp
  ret

global x86_Disk_Reset
x86_Disk_Reset:
  [bits 32]

  ; make new call frame
  push ebp                           ; save old call frame
  mov ebp, esp                        ; initialize new call frame

  x86_EnterRealMode
  
  mov ah, 0
  mov dl, [bp + 8]                  ; dl - drive
  stc
  int 13h

  mov eax, 1
  sbb eax, 0                         ; 1 on success, 0 on fail

  push eax

  x86_EnterProtectedMode

  pop eax

  ; restore old call frame
  mov esp, ebp
  pop ebp
  ret

global x86_Disk_Read
x86_Disk_Read:
  [bits 32]

  ; make new call frame
  push ebp                           ; save old call frame
  mov ebp, esp                        ; initialize new call frame

  x86_EnterRealMode

  ; save modified regs
  push ebx
  push es
  
  ; setup args
  mov dl, [bp + 8]                  ; dl - drive
  mov ch, [bp + 12]                 ; ch - cylinder (lower 8 bits)
  mov cl, [bp + 13]                 ; cl - cylinder to bits 6-7
  shl cl, 6
  mov al, [bp + 16]                 ; cl - sector to bits 0-5
  and al, 3Fh
  or cl, al
  mov dh, [bp + 20]                 ; dh - head
  mov al, [bp + 24]                 ; al - count
  LinearToSegOffset [bp + 28], es, ebx, bx

  ; call interrupt
  mov ah, 02h
  stc
  int 13h

  mov eax, 1
  sbb eax, 0                         ; 1 on success, 0 on fail

  ; restore regs
  pop es
  pop ebx

  push eax

  x86_EnterProtectedMode

  pop eax

  ; restore old call frame
  mov esp, ebp
  pop ebp
  ret
