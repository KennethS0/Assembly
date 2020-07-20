evaluator: evaluator.o
	ld evaluator.o -o evaluator

evaluator.o: evaluator.asm
	nasm -f elf64 -o evaluator.o evaluator.asm

clean: 
	rm *.o evaluator