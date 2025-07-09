(** Types for the "components" of a Turing machine and a type for the machines
    themselves, along with functions to work with the values of these types.

    The types are parametrized with other types, denoting the type of the
    alphabet and the type of the states. *)


(** {1 Types and Representations} *)

(** {2 Tape} *)

(** If the symbols on the tape are values of type ['a], then the tape is
    represented by two lists, say {m L : 'a\,\mathrm{option}} and
    {m R : 'a\,\mathrm{option}}, and a value {m v : 'a} such that the head
    currently points to {m v}, and {m L} and {m R} denote how the tape is to
    the left and right of {m v} respectively.

    For example, consider the following contiguous section of a tape at some
    point in time:

        {m \dots, 1, \cdot, 1, \cdot, \overline 1, \cdot, \cdot, 1, 1, \dots}

    Assuming that {m \cdot} denotes the blank symbol, the head is at
    {m \overline 1} and the tape to the left and right of this region is
    completely blank, the representation would be:

        [v : int = 1]

        [L : int option list = [None; Some 1; None; Some 1]]

        [R : int option list = [None; None; Some 1; Some 1]] *)
type 'a tape =
    Tape of 'a option list * 'a option * 'a option list             (** {m L, v, R} *)

(** Helper function to construct a tape. *)
val make_tape : 'a option list -> 'a option -> 'a option list -> 'a tape

(** Makes an empty tape - a tape with all cells blank. *)
val empty_tape : unit -> 'a tape


(** Gives the value at the head for a tape. *)
val tape_head : 'a tape -> 'a option


(** {2 Actions} *)

(** Type to capture what the head is supposed to do after a step - whether it
    should move one cell left, move one cell right, or do nothing. *)
type action =
    | Left
    | Right
    | Nothing


(** {2 Machine} *)

(** Type for a Turing machine with alphabets being values of the type ['a]
    and states being values of the type ['q]. This representation is inspired
    from the 7-tuple formalization mentioned on
    {{:https://en.wikipedia.org/wiki/Turing_machine#Formal_definition} Wikipedia},
    namely

    {m M = \langle Q, \Gamma, b, \Sigma, \delta, q_0, F \rangle}

    A slightly more detailed description follows.
        + ['a]: Values of this type are considered to be the alphabets that can
        be placed inside the tape's cells. This type is analogous to {m \Gamma}.
        As the tape representation uses ['a option] instead of ['a], there is no
        need for an explicit {m b}.
        + ['q]: Values of this type are considered to be the states, so this
        type is analogous to {m Q}.
        + [state]: A value of ['q], denoting the current state. Initially, this
        is {m q_0}.
        + [f_states]: Contains ['q] values which are considered to be final
        states. This is analogous to {m F}.
        + [delta]: A curried function meant to take the current state and the
        alphabet at the head, to obtain the next state, the new symbol to be
        written at the head position, and the action that the head should
        perform after the writing, which is a value of [action]. Analogous to
        {m \delta:(Q\backslash F)\times\Gamma\to Q\times\Gamma\times\{L, R, N\}}.
        + [tape]: The current tape, which implicitly knows where the head is,
        due to the type [tape].
        + [printer_a]: Function to print a symbol from the alphabet.
        + [printer_q]: Function to print a state.

    {b Catches/Differences}:
        + {m \Sigma} is not kept track of, it's only used once while validating
        the input tape.
        + No attention is paid to whether ['a] and ['q] are finite.
        + The Wikipedia definition doesn't include {m N} as an action, but this
        definition does, to denote that the head stays in place. *)
type ('a, 'q) t =
    { state : 'q ;
      f_states : 'q list ;
      delta : 'q -> 'a option -> 'q * 'a option * action ;
      tape : 'a tape ;
      printer_a : 'a -> unit ;
      printer_q : 'q -> unit }


(** Validates the input tape with {m \Sigma} - ensures that it doesn't have
    any non-blank symbols that are not in {m \Sigma}. *)
val validate_tape : 'a tape -> 'a list -> bool

(** Helper function to construct a Turing machine. *)
val make_machine :
    'q -> 'q list -> 'a list
        -> ('q -> 'a option -> 'q * 'a option * action) -> 'a tape
            -> ('a -> unit) -> ('q -> unit)
                -> ('a, 'q) t


(** {1 Printing Functions} *)


(** Print the value at the tape head. *)
val print_head : ('a, 'q) t -> unit

(** Print the smallest continguous section of the tape such that everything
    to it's left and right is just empty cells.

    The symbol at the head is printed in bold cyan with a dark purple background
    using ANSI escape codes. *)
val print_tape : ('a, 'q) t -> unit

(** Prints the tape with [n] entries to either side of the head, [n] being
    the second argument to the function. *)
val print_tape_extended : ('a, 'q) t -> int -> unit

(** Prints a total of [n1] cells of the tape, with the head being at an offset
    of [n2] (in the [n2]'th cell, starting from 1).

    NOTE:   For now, it only accepts [1 <= n1] and [1 <= n2 <= n1]. *)
val print_tape_pretty : ('a, 'q) t -> int -> int -> unit

(** Print the state that the machine is currently in. *)
val print_current_state : ('a, 'q) t -> unit

(** Print all the states in [m.f_states] ({m F} analogue). *)
val print_f_states : ('a, 'q) t -> unit

(** Print some general info about the machine. Just a convenient way to use
    the other printing functions above together. *)
val print_machine : ('a, 'q) t -> unit




(** {1 Operational Functions} *)


(** Updates a tape based on an action and returns the resultant tape. *)
val move_head : 'a tape -> action -> 'a tape

(** "Run" a machine - perform one "step" of "evaluation" baesd on the
    machine's parameters - namely it's tape head, state and {m \delta}. *)
val run : ('a, 'q) t -> ('a, 'q) t

(** Run a machine till it halts. If it doesn't, run it forever. *)
val run_till_halt : ('a, 'q) t -> ('a, 'q) t

(** "Runs" the machine, displaying it's info at each stage using
    [print_machine], along with the stage number. *)
val execute : ('a, 'q) t -> unit

(** "Runs" the machine, displaying it's tape at each stage, with [n] entries
    to the left and right of the head, [n] being the second argument to the
    function.

    This makes it look like the head stays fixed in one position and the tape
    moves back and forth between stages. *)
val execute_moving_tape : ('a, 'q) t -> int -> unit


(** "Runs" the machine, displaying it's tape using the {!print_tape_pretty}
    function. So, it prints the tape in each stage with [n1] of it's entries,
    with the head being at an offset of [n2] in the first stage, and the tape in
    the subsequent stages is printed as if it's the head that's moving across
    that same section of the tape, rather than the tape moving while the head
    stays fixed (like in {!print_tape_extended}).

    The int option parameter which is set to [None] by default is for a limit on
    the number of stages. *)
val execute_moving_head : ('a, 'q) t -> ?limit:int option -> int -> int -> unit


(** Executes a Turing machine, only displaying the info at the point when the
    machine halts, along with how many steps it took to get to that stage. This
    speeds up the process immensely. In concrete terms, running the 5-state Busy
    Beaver machine (from [examples/bb5.ml]) only takes ~2.5 seconds, for
    47,176,870 steps. *)
val execute_fast : ('a, 'q) t-> unit

