hola_nuevo: hola_nuevo.o
	ld hola_nuevo.o -o hola_nuevo

hola_nuevo.o: hola_nuevo.asm
	nasm -f elf64 -o hola_nuevo.o hola_nuevo.asm

clean: 
	rm *.o hola_nuevo
