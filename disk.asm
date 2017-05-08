; disk_load_pm(int16 address, int8 sector_count, int8 drive) 
disk_load_rm:
	push bp
	mov bp, sp
	pusha
	
	; bp + 6 - address
	; bp + 4 - sectors + drive
	
	mov bx, [bp + 6]
	mov dx, [bp + 4]
	
	mov ah, 0x02     	; BIOS  read  sector  function
	mov al, dh       	; Read DH  sectors
	mov ch, 0x00     	; Select  cylinder 0
	mov dh, 0x00     	; Select  head 0
	mov cl, 0x02     	; Start  reading  from  second  sector (i.e. after  the  boot  sector)
	int 0x13          	; BIOS  interrupt
	
	jc disk_error    	; Jump if error (i.e.  carry  flag  set)
	
	mov dx, [bp + 4]
	cmp dh, al       	; if AL (sectors  read) != DH (sectors  expected)
	jne DISK_WRONG_SECTOR_COUNT_MSG   	; display  error  message
	
	popa
	pop bp
	ret


; disk error
disk_error:
	push DISK_ERROR_MSG
	call print_string_rm
	pop bx
	
	jmp $

; variables
DISK_ERROR_MSG:
	db "Disk read error!", 0
DISK_WRONG_SECTOR_COUNT_MSG:
	db "Incorrect number of sectors read!", 0
