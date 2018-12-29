CC=gcc
CFLAGS=-m32

ASM=nasm
AFLAGS=-f elf32

all:result

main.o: main.c
	$(CC) $(CFLAGS) -c main.c
removerng.o: removerng.asm
	$(ASM) $(AFLAGS) removerng.asm
result: main.o removerng.o
	$(CC) $(CFLAGS) main.o removerng.o -o result
clean: 
	rm *.o
	rm result
