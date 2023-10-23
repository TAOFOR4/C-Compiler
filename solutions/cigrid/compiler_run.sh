./cigrid --asm test2.txt > a.asm
nasm -felf64 a.asm
gcc -no-pie a.o
./a.out