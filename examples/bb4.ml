(** A 4-state Busy Beaver created using the [Tm] library. *)


open Tm.Machine


(** {1 Machine description} *)

(** This machine is a 4-state Busy Beaver. It is taken from
    {{:https://en.wikipedia.org/wiki/Busy_beaver#List_of_busy_beavers} Wikipedia}. *)

(** The machine has four "actual" states, [A], [B], [C] and [D], with an
    additional state [HALT] - the only final state. *)
type state =
    | A | B | C | D | HALT

(** The initial state is [A]. *)
let init_state = A

(** The only final state is [HALT]. *)
let f_states = [ HALT ]


(** There are two symbols that can be on the tape - [0] and [1], so we will
    choose the following type with just one constructor as the alphabet type.
    [Some One] denotes [1] and [None] denotes [0]. *)
type alphabet =
    | One

(** [One] is allowed to be on the input tape. *)
let sigma = [ One ]

(** The inital tape is completely blank. *)
let init_tape = empty_tape ()


(** Printer function for the alphabet. *)
let p_a = function
    | One -> Printf.printf "1"

(** Printer function for the states. *)
let p_q = function
    | A -> Printf.printf "A"
    | B -> Printf.printf "B"
    | C -> Printf.printf "C"
    | D -> Printf.printf "D"
    | HALT -> Printf.printf "HALT"


(** {2 Transition function} *)

(** Transition from [A].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Right |       B       |
       | 1      | 1     | Left  |       B       |} *)
let delta_A = function
    | Some One -> (B, Some One, Left)
    | None -> (B, Some One, Right)

(** Transition from [B].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Left  |       A       |
       | 1      | 0     | Left  |       C       |} *)
let delta_B = function
    | Some One -> (C, None, Left)
    | None -> (A, Some One, Left)

(** Transition from [C].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Right |       HALT    |
       | 1      | 1     | Left  |       D       |} *)
let delta_C = function
    | Some One -> (D, Some One, Left)
    | None -> (HALT, Some One, Right)

(** Transition from [D].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Right |       D       |
       | 1      | 0     | Right |       A       |} *)
let delta_D = function
    | Some One -> (A, None, Right)
    | None -> (D, Some One, Right)

(** Serves no purpose other than making the delta function
    define-able. *)
let delta_HALT _ = (HALT, None, Nothing)

(** The main transition function, combining {!delta_A}, {!delta_B}, {!delta_C}
    and {!delta_D}. *)
let delta q s =
    match q with
    | A -> delta_A s
    | B -> delta_B s
    | C -> delta_C s
    | D -> delta_D s
    | HALT -> delta_HALT s


(** {2 The Turing machine} *)

(** A result of {!Tm.Machine.make_machine} with all the above values passed to
    it. *)
let m = make_machine init_state f_states sigma delta init_tape p_a p_q


