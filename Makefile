all: ./bin/myos.iso

./bin/myos.iso: ./bin/myos.bin
	cp ./src/grub.cfg ./isodir/boot/grub/grub.cfg
	cp ./bin/myos.bin ./isodir/boot/myos.bin
	grub-mkrescue -o myos.iso isodir

./bin/myos.bin: ./build/boot.o ./build/kernel.o
	i686-elf-gcc -T ./src/linker.ld -o ./bin/myos.bin -ffreestanding -O2 -nostdlib ./build/boot.o ./build/kernel.o -lgcc

./build/boot.o: ./src/boot.s
	i686-elf-as ./src/boot.s -o ./build/boot.o

./build/kernel.o: ./src/kernel.c
	i686-elf-gcc -c ./src/kernel.c -o ./build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

clean: 
	rm -rf ./bin ./build ./isodir ./myos.iso
