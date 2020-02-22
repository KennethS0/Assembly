mayus_minus: mayus_minus.o
	ld mayus_minus.o -o mayus_minus

mayus_minus.o: mayus_minus.asm
	nasm -f elf64 -o mayus_minus.o mayus_minus.asm

clean: 
	rm *.o mayus_minus