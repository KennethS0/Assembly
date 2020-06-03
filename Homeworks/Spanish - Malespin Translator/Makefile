translator: translator.o
	ld translator.o -o translator

translator.o: translator.asm
	nasm -f elf64 -o translator.o translator.asm

clean: 
	rm *.o translator