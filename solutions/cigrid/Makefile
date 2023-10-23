

.PHONY: clean

all:
	ocamlbuild -use-menhir main.native
	mv main.native cigrid

clean:
	ocamlbuild -clean
	@rm -f *~ main.native \#*
