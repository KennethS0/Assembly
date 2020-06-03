sum-dif: sum-dif.o
	ld sum-dif.o -o sum-dif

sum-dif.o: sum-dif.asm
	nasm -f elf64 -o sum-dif.o sum-dif.asm

clean: 
	rm *.o sum-dif
