[![pipeline status](https://gitlab.com/rajdeep-314/turing-machines-ocaml/badges/main/pipeline.svg)](https://gitlab.com/rajdeep-314/turing-machines-ocaml/-/commits/main)



# Turing Machines

The project contains a library that you can use to define your own Turing
machines, along with a few [examples](#examples) that demonstrate the same.


# Contents

- [Documentation](#documentation)
- [Examples](#examples)
    - [BB(n)](#bbn)
    - [First](#first)
    - [Rajdeep](#rajdeep)
- [Using as a library](#using-as-a-library)
    - [Types and values](#types-and-values)
    - [Transition function](#transition-function)
    - [The machine](#the-machine)
    - [Execution](#execution)
- [Issues](#issues)


# Documentation

I've used [Odoc](https://github.com/ocaml/odoc) to generate the documentation
from comments in the source code. You can read the documentation online
[here](https://rajdeep-314.gitlab.io/turing-machines-ocaml) or build it yourself
fromn the source code using Odoc like so

```bash
# Build the documentation.
dune build @doc

# Open in browser.
xdg-open _build/default/_doc/_html/index.html
```



# Examples

The code for each of the examples can be found in the [examples](examples/)
directory, and their corresponding executables are in the [bin](bin/) directory,
with the same name as in `examples/`.

To execute an example with the name `expl`, run

```bash
dune exec expl
```

Read the documentation for the examples [here](https://rajdeep-314.gitlab.io/turing-machines-ocaml/tm/Examples/index.html).


## BB(n)

There are five Busy Beaver machines in the examples - $BB(1)$ through $BB(5)$.

While the $BB(1)$ through $BB(4)$ machines halt in a few steps ($< 150$), that
isn't the case for $BB(5)$, which halts after $47,176,870$ steps. So, it's not
practical to run the $BB(5)$ machine and show the tape at all steps, which is
why I've used the `Tm.Machine.execute_fast` function instead of the usual
`Tm.Machine.execute_moving_head` inside it's executable, which executes till
halt, and then shows the number of steps taken, the final tape and the final
state.

For $BB(1)$ through $BB(4)$, the machine displays information for each step till
halt. This information includes the tape, the head's position and the state.

The final tapes for each of the Busy Beaver machines can be found in the
[final-tapes](final-tapes/) directory.

Here's the output of $BB(3)$ as an example.

```bash
> dune exec bb3

[ 3-state Busy Beaver ]

1:		| . | . | . | . | . | . | 		[ A ]
2:		| . | . | . | 1 | . | . | 		[ B ]
3:		| . | . | . | 1 | 1 | . | 		[ A ]
4:		| . | . | . | 1 | 1 | . | 		[ C ]
5:		| . | . | 1 | 1 | 1 | . | 		[ B ]
6:		| . | 1 | 1 | 1 | 1 | . | 		[ A ]
7:		| 1 | 1 | 1 | 1 | 1 | . | 		[ B ]
8:		| 1 | 1 | 1 | 1 | 1 | . | 		[ B ]
9:		| 1 | 1 | 1 | 1 | 1 | . | 		[ B ]
10:		| 1 | 1 | 1 | 1 | 1 | . | 		[ B ]
11:		| 1 | 1 | 1 | 1 | 1 | . | 		[ B ]
12:		| 1 | 1 | 1 | 1 | 1 | 1 | 		[ A ]
13:		| 1 | 1 | 1 | 1 | 1 | 1 | 		[ C ]
14:		| 1 | 1 | 1 | 1 | 1 | 1 | 		[ HALT ]
```

If your terminal supports ANSI escape codes, then the head location on each tape
would be highlighted in purple.


## First

This is the first example that [Alan Turing](https://en.wikipedia.org/wiki/Alan_Turing)
gave. I took the machine descrption from
[Wikipedia](https://en.wikipedia.org/wiki/Turing_machine_examples#Turing's_very_first_example).

The machine endlessly prints alternating `0` and `1` on the tape, with a blank
cell between each of the symbols.

Here's what executing it looks like.

```bash
> dune exec first

[ Turing's very first example ]    

1:		| . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ B ]
2:		| . | 0 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ C ]
3:		| . | 0 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ E ]
4:		| . | 0 | . | 1 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ F ]
5:		| . | 0 | . | 1 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ B ]
6:		| . | 0 | . | 1 | . | 0 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ C ]
7:		| . | 0 | . | 1 | . | 0 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ E ]
8:		| . | 0 | . | 1 | . | 0 | . | 1 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ F ]
9:		| . | 0 | . | 1 | . | 0 | . | 1 | . | . | . | . | . | . | . | . | . | . | . | . | . | . | 		[ B ]
10:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | . | . | . | . | . | . | . | . | . | . | . | 		[ C ]
11:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | . | . | . | . | . | . | . | . | . | . | . | 		[ E ]
12:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | . | . | . | . | . | . | . | . | . | 		[ F ]
13:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | . | . | . | . | . | . | . | . | . | 		[ B ]
14:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | . | . | . | . | . | . | . | 		[ C ]
15:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | . | . | . | . | . | . | . | 		[ E ]
16:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | . | . | . | . | . | 		[ F ]
17:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | . | . | . | . | . | 		[ B ]
18:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | . | . | . | 		[ C ]
19:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | . | . | . | 		[ E ]
20:		| . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | 0 | . | 1 | . | . | 		[ F ]
```

## Rajdeep

A simple Turing machine that prints my name on the tape before halting. It has
seven states other than the halting state - one for each letter of my name.

Here's what executing it looks like.

```bash
> dune exec rajdeep

[ A prints-my-name-on-the-tape Turing machine ]

1:		| . | . | . | . | . | . | . | . | 		[ S1 ]
2:		| R | . | . | . | . | . | . | . | 		[ S2 ]
3:		| R | A | . | . | . | . | . | . | 		[ S3 ]
4:		| R | A | J | . | . | . | . | . | 		[ S4 ]
5:		| R | A | J | D | . | . | . | . | 		[ S5 ]
6:		| R | A | J | D | E | . | . | . | 		[ S6 ]
7:		| R | A | J | D | E | E | . | . | 		[ S7 ]
8:		| R | A | J | D | E | E | P | . | 		[ H ]
```



# Using as a library

If you're familiar with OCaml and Dune, reading the [documentation](https://rajdeep-314.gitlab.io/turing-machines-ocaml)
and the source code should be enough for you to make your own Turing machines
using the `Tm` library in this project. But, here's a general "guide"
nonetheless.

Start by opening the module `Machine` from the library `Tm` to avoid writing
verbose names.

```ocaml
open Tm.Machine
```

## Types and values

Define OCaml types, the values of which represent the states of your Turing
machine and the symbols of the alphabet for your machine's tape. Let's call
these types `state` and `alphabet` respectively.

There is no need to reserve a value of `alphabet` to denote the blank symbol, as
the tape's representation associates with each cell a value of the type
`'a option` for some type `'a`. So, for your alphabet type `alphabet`, `None`
will denote the blank symbol and `Some s` for `s : alphabet` will denote `s`
being on a cell. Define OCaml types that represent the states of your turing
machine and the alphabet.

So far, we have

```ocaml
type state
type alphabet
```

Next, define some values that will act as parameters for defining your machine.
These values include an initial state and a list of final states. Any state that
is a member of this list of final states is considered to be a halting state.
Let us refer to these values as `init_state` and `f_states`.

So, we now have

```ocaml
val init_state : state
val f_states : state list
```

Now, define `sigma` and `inital_tape`, where `sigma` is a list of symbols that
are allowed on the inital tape, and `initial_tape` is exactly what it suggests -
the initial tape.

```ocaml
val sigma : alphabet list
val initial_tape : alphabet tape
```

`empty_tape : unit -> 'a tape` is a function that gives an empty tape with
alphabets of type `'a`. So, use `let initial_tape : alphabet tape = empty_tape ()`
to make the inital tape blank. For a non-empty tape, you can use the function
`make_tape : 'a option list -> 'a option -> 'a option list` to make a tape from
the left-tape, the right-tape and the value at the tape head. Read more about
this function (and other related ones) from the documentation
[here](https://rajdeep-314.gitlab.io/turing-machines-ocaml/tm/Tm/Machine/index.html#types-and-representations).

Make printer functions, say `p_a` and `p_q`, to provide the string
representation of the alphabet and the states. These functions are used to print
things during the machine's execution.

```ocaml
val p_a : alphabet -> string
val p_q : state -> string
```

## Transition function

Now, the main part. Define the transition function `delta` with the signature
```ocaml
val delta : state -> alphabet option -> state * alphabet option * action
```

Basically, if `delta q s` gives `(q', s', act)`, then it means that if the head
is at `s` in the machine state `q`, then after the operation, the symbol at the
head will change to `s'`, the machine state to `q'` and the head will perform
the action `act`. To read more about this and the type `action`, consult the
[documentation](
https://rajdeep-314.gitlab.io/turing-machines-ocaml/tm/Tm/Machine/index.html#machine)
(as always!).

It's probably easier in practice to first define `delta_q` functions for each
state `q` of your machine and then combine them in a main `delta` function, like
I've done in all of the [examples](examples/).

## The machine

Now, you have everything you need to make the machine. With the values and types
we have defined above, we can make our machine like so

```ocaml
let m : (alphabet, state) t =
        make_machine init_state f_states sigma delta initial_tape p_a p_q
```

## Execution

There are currently four execution "modes" available.

> `execute_moving_head : ('a, 'q) t -> ?limit:int option -> int -> int -> unit`

`execute_moving_head mn l m n` executes `mn`, either till the machine halts, or
the number of steps reach the limit specified by `l` (if specified, at all). `m`
and `n` are parameters for the way the tape is displayed in each step. The tape
shows $m$ cells, with the head initially being at the $m^{\mathrm{th}}$ cell
from the left.

With ANSI escape codes, the head symbol is shown as cyan on a purple background
in each tape.

The function's name includes "moving head" because the way the tape is displayed
makes it look like the head of the tape is moving, as the tape remains
stationary, with respect to the screen.

> `execute_moving_tape : ('a, 'q) t -> int -> unit`

`execute_moving_tape mn x` executes the machine `mn` till it halts, $2x + 1$
cells of the tape displayed for each step, with the head in the middle, and $x$
cells to either of it's sides.

This makes it look like the head is stationary relative to the screen, and it's
the tape that's moving - hence the function's name.

> `execute_fast : ('a, 'q) t -> unit`

`execute_fast mn` executes the machine `mn` with a focus on speed, not bothering
with printing information about the machine at each step of execution, and only
printing the number of steps to it's halting, and the tape at the halted state.

Checking if my [BB(5)](examples/bb5.ml) implementation was correct is what led
me to make this function.

> `execute : ('a, 'q) t -> unit`

This is the most basic of these functions, and very boring. I'd ask you to just
not use it.


So, you can use any of these functions to execute your machine and print stuff
to the screen. For example, to execute `m` in the standard head-moving fashion,
you would do this

```ocaml
let () = execute_moving_head m
```


# Issues

Please leave any bug reports, suggestions, etc
[here](https://github.com/rajdeep-314/turing-machines-ocaml/issues).


