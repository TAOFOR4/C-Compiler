

.PHONY: clean

all:
	ocamlbuild main.native
	mv main.native calc

clean:
	ocamlbuild -clean
	rm -f *~ main.native \#*
