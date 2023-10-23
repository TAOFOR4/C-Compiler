

.PHONY: all clean

all:
	gcc -c factorial.c
	gcc -c main-c.c
	gcc -g main-c.o factorial.o -o main-c

	nasm -felf64 main-asm.asm -o main-asm.o
	gcc -no-pie factorial.o main-asm.o -o main-asm

clean:
	rm -f *.o main-c main-asm factorial.o *~
