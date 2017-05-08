all: os-image

boot.bin: boot.asm
	nasm $< -f bin -o $@

# $^ is  substituted  with  all of the  target ’s dependancy  files
kernel.bin: kernel_entry.o kernel.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 $^ --oformat binary

# $< is the  first  dependancy  and $@ is the  target  file
kernel.o: kernel.c
	gcc -O0 -m32 -ffreestanding -c $< -o $@

# Same as the  above  rule.
kernel_entry.o: kernel_entry.asm
	nasm $< -f elf32 -o $@

os-image: boot.bin kernel.bin
	cat $^ > $@

clean:
	rm *.o *.bin os-image
