

# NASM test files
By David Broman. Supplemantary material to lecture 4.

To compile all files, just run

```
make
```

Note that the `Makefile` is generic, meaning that it will compile any
`.asm` file in the directory. Please check out the `Makefile` if you
are intrested to know how this works.

After compilation, you can test the different files. All executable
files have the ending `.out`. For instance, to try out the
command-line test, run for instance:

```
./command-args.asm.out Here we are
```

which will print out:

```
4
./command-args.asm.out
Here
we
are
```