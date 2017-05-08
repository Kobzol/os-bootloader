[bits 16]
switch_to_pm:
	cli						; turn off interrupts
	lgdt [gdt_descriptor]	; load GDT descriptor	
	
	mov eax, cr0			; switch to protected mode
	or eax, 0x1
	mov cr0, eax
	
	jmp CODE_SEG:init_pm

[bits 32]
init_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000
	mov esp, ebp

	call start
	jmp $
