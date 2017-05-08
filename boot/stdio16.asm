print_string_rm:
	push bp
	mov bp, sp
	pusha
	
	mov ah, 0x0E ; tty mode
	mov bx, [bp + 4]

.loop:
	mov al, BYTE [bx] ; load char
	cmp al, 0	 ; check end of string
	je .end
	int 0x10	 ; print char
	inc bx		 ; increment string pointer
	jmp .loop
	
.end:
	popa
	pop bp
	ret

print_hex_rm:
	push bp
	mov bp, sp
	pusha
	
	mov bx, HEX_OUT + 2
	mov dx, 4

.loop:
	mov ax, [bp + 4]
	mov cx, dx
	dec cx
	shl cx, 2
	shr ax, cl
	and ax, 0x000F
	add ax, HEX_CHARS	; map to character
	mov si, ax
	mov al, BYTE [si]
	mov [bx], al
	inc bx
	dec dx
	cmp dx, 0
	je .end
	jmp .loop

.end:
	sub bx, 6	; move to beginning of string (0x)
	push bx
	call print_string_rm
	pop bx

	popa
	pop bp
	ret

HEX_OUT:
	db "0x0000",10,13,0
HEX_CHARS:
	db "0123456789ABCDEF"
