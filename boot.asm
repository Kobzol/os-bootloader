[org 0x7C00]
[bits 16]

KERNEL_OFFSET equ 0x1000

mov bp, 0x9000	; setup stack
mov sp, bp

mov [BOOT_DRIVE], dl

push KERNEL_OFFSET
mov ah, 1
mov al, [BOOT_DRIVE]
push ax
call disk_load_rm

call switch_to_pm
jmp $

; includes
%include "gdt.asm"
%include "disk.asm"
%include "stdio16.asm"
%include "stdio.asm"
%include "switch_pm.asm"

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
