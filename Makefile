# $^ is  substituted  with  all of the  target ’s dependancy  files
# $< is the  first  dependancy  and $@ is the  target  file

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

CFLAGS = -g -O0 -m32 -ffreestanding

all: os-image

run: os-image
	qemu-system-x86_64 -drive format=raw,file=os-image
	
debug: os-image kernel/kernel.elf
	qemu-system-x86_64 -s -drive format=raw,file=os-image &
	gdb -ex "target remote localhost:1234" -ex "symbol-file kernel/kernel.elf"
	

# OS image
os-image: boot/boot.bin kernel/kernel.bin
	cat $^ > $@

# kernel for debug
kernel/kernel.elf: kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

# kernel link
kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

%.o : %.c ${HEADERS}
	gcc ${CFLAGS} -c $< -o $@

# boot
%.bin: %.asm
	nasm $< -f bin -o $@

# kernel entry
%.o: %.asm
	nasm $< -f elf32 -o $@

clean:
	rm -rf os-image
	rm -rf kernel/*.o kernel/*.bin kernel/*.elf boot/*.bin drivers/*.o
