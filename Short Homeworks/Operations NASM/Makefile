operations: operations.o
	ld operations.o -o operations

operations.o: operations.asm
	nasm -f elf64 -o operations.o operations.asm

clean: 
	rm *.o operations
