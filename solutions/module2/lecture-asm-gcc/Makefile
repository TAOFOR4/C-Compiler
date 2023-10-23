# Some tutorials related to Make files
# https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# https://www.gnu.org/software/make/manual/html_node/Introduction.html
# https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html
#
# Note1: $@ is the file before : and $^  is the file
# Note2: We need to need to add -no-pie on gcc
# See https://stackoverflow.com/questions/46123505/assembling-with-gcc-causes-weird-relocation-error-with-regards-to-data

.PHONY: all clean

OBJ = $(patsubst %.asm,%.o,$(wildcard *.asm))

all: $(OBJ)

%.o: %.asm
	nasm -felf64 $^
	gcc -no-pie $@ -o $^.out

clean:
	rm -f *.o a.out *~ \#* *.out





