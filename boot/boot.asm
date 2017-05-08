[org 0x7C00]
[bits 16]

KERNEL_OFFSET equ 0x1000

mov bp, 0x9000	; setup stack
mov sp, bp

mov [BOOT_DRIVE], dl

push KERNEL_OFFSET
mov ah, 17	; update as program grows
mov al, [BOOT_DRIVE]
push ax
call disk_load_rm

call switch_to_pm
jmp $

; includes
%include "boot/gdt.asm"
%include "boot/disk.asm"
%include "boot/stdio16.asm"
%include "boot/stdio.asm"
%include "boot/switch_pm.asm"

[bits 32]
start:
	call KERNEL_OFFSET
	jmp $

BOOT_DRIVE:
	db 0
	
TEST_STR:
	db "Hello", 0

; padding and magic number
times 510 - ($-$$) db 0
dw 0xAA55
