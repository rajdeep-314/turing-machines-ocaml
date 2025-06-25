# Turing Machines

I'm attempting to implement Turing machines in OCaml, at least to the extent
that I understand them (very little).


# Execution

I've prepared a demo on how to use the library to make the 3-state Busy Beaver
machine described here on [Wikipedia](https://en.wikipedia.org/wiki/Turing_machine#Formal_definition).

The source code for that is present in the `demo/` directory.

You can execute the top-level program for this demo using
```bash
dune exec demo
```


# Using as a library

[ Coming soon ]


# Documentation

Run this to generate the documentation through [Odoc](https://github.com/ocaml/odoc)
```bash
dune build @doc
```

You can then find the HTML documentation in
```
./_build/default/_doc/_html/
```

Open `index.html` from that directory to start reading through the documentation.

