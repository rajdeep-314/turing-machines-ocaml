(** A 3-state Busy Beaver created using the [Tm] library. *)


open Tm.Machine


(** {1 Machine description} *)

(** This machine is a 2-state Busy Beaver. *)

(** Two actual states, [A] and [B], and only one final state [HALT]. *)
type states =
    A | B | HALT

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
       | 1      | 1     | Right |       HALT    |} *)
let delta_B = function
    | Some One -> (HALT, Some One, Right)
    | None -> (A, Some One, Left)

(** Serves no purpose other than making the delta function
    define-able. *)
let delta_HALT _ = (HALT, None, Nothing)

(** The main transition function, combining {!delta_A} and {!delta_B}. *)
let delta q s =
    match q with
    | A -> delta_A s
    | B -> delta_B s
    | HALT -> delta_HALT s


(** {2 The Turing machine} *)

(** A result of {!Tm.Machine.make_machine} with all the above values passed to
    it. *)
let m = make_machine init_state f_states sigma delta init_tape p_a p_q


