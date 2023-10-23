# OCaml Template

This is the OCaml template for the ID2202 course. Like the other templates,
building happens with `make`, running with `./hello`. The project is built using
[`ocamlbuild`](https://github.com/ocaml/ocamlbuild). To install `ocamlbuild`, it
is easiest to first install [`opam`](https://opam.ocaml.org/) and then run

```bash
opam install ocamlbuild
```

To use this template for an assignment, replace these lines in the `Makefile`:

```
ocamlbuild hello.native
mv hello.native hello
```

For example, if your main source file is `calc.ml`, then the lines become:"

```
ocamlbuild calc.native
mv calc.native calc
```

Remember to ignore the new file in `.gitignore`.
