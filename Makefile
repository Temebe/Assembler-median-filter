CC=gcc
CFLAGS=-m32 -fpack-struct=1

ASM=nasm
AFLAGS=-f elf32

all:result

main.o: main.c
	$(CC) $(CFLAGS) -c main.c
median.o: median.asm
	$(ASM) $(AFLAGS) median.asm
result: main.o median.o
	$(CC) $(CFLAGS) main.o median.o -o result
clean: 
	rm *.o
	rm result
