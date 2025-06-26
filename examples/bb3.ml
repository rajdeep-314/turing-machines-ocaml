(** A 3-state Busy Beaver created using the [Tm] library. *)


open Tm.Machine


(** {1 Machine description} *)

(** This machine is a 3-state Busy Beaver. It's taken from
    {{:https://en.wikipedia.org/wiki/Turing_machine#Formal_definition} Wikipedia}. *)

(** The machine has four states, [A], [B], [C] and [HALT], the last one being
    the only state at which the machine is said to have halted. *)
type state =
    | A | B | C | HALT

(** The initial state is [A]. *)
let init_state = A

(** The only final state is [HALT]. *)
let f_states = [ HALT ]


(** There are meant to be two symbols in the alphabet including the black symbol.
    For our encoding where the actual symbols on the tape are ['a option] values
    for some type ['a], this type will serve as ['a], with [Some One] denoting
    [1] and [None] denoting [0]. *)
type alphabet =
    | One

(** [One] is allowed to be on the input tape. *)
let sigma = [ One ]

(** The inital tape is completely blank. *)
let init_tape = make_tape [] None []


(** Printer function for the alphabet. *)
let p_a = function
    | One -> Printf.printf "1"

(** Printer function for the states. *)
let p_q = function
    | A -> Printf.printf "A"
    | B -> Printf.printf "B"
    | C -> Printf.printf "C"
    | HALT -> Printf.printf "HALT"


(** {2 Transition function} *)

(** Transition from [A].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Right |       B       |
       | 1      | 1     | Left  |       C       |} *)
let delta_A = function
    | Some One -> (C, Some One, Left)
    | None -> (B, Some One, Right)

(** Transition from [B].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Left  |       A       |
       | 1      | 1     | Right |       B       |} *)
let delta_B = function
    | Some One -> (B, Some One, Right)
    | None -> (A, Some One, Left)

(** Transition from [C].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Left  |       B       |
       | 1      | 1     | Right |       HALT    |} *)
let delta_C = function
    | Some One -> (HALT, Some One, Right)
    | None -> (B, Some One, Left)

(** Serves no purpose other than making the delta function
    define-able. *)
let delta_HALT _ = (HALT, None, Nothing)

(** The main transition function, combining {!delta_A}, {!delta_B} and
    {!delta_C}. *)
let delta q s =
    match q with
    | A -> delta_A s
    | B -> delta_B s
    | C -> delta_C s
    | HALT -> delta_HALT s


(** {2 The Turing machine} *)

(** A result of {!Tm.Machine.make_machine} with all the above values passed to
    it. *)
let m = make_machine init_state f_states sigma delta init_tape p_a p_q


