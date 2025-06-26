(** A 1-state Busy Beaver created using the [Tm] library. *)


open Tm.Machine


(** {1 Machine description} *)

(** This machine is a 1-state Busy Beaver. *)

(** One actual state [A] and one final state [HALT]. *)
type states = A | HALT

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
let init_tape = make_tape [] None []


(** Printer function for the alphabet. *)
let p_a = function
    | One -> Printf.printf "1"

(** Printer function for the states. *)
let p_q = function
    | A -> Printf.printf "A"
    | HALT -> Printf.printf "HALT"


(** {2 Transition function} *)

(** Transition from [A].

    {t | Symbol | Write | Move  | Next State    |
       |--------|-------|-------|---------------|
       | 0      | 1     | Right |       HALT    |
       | 1      | 0     | Nil   |       A       |}

    NOTE:   The transition for the symbol [1] is never actually used, due to how
    the machine is. *)
let delta_A = function
    | Some One -> (HALT, None, Nothing)
    | None -> (HALT, Some One, Right)

(** Serves no purpose other than making the delta function
    define-able. *)
let delta_HALT _ = (HALT, None, Nothing)

(** The main transition function, combining {!delta_A} and {!delta_HALT}. *)
let delta q s =
    match q with
    | A -> delta_A s
    | HALT -> delta_HALT s


(** {2 The Turing machine} *)

(** A result of {!Tm.Machine.make_machine} with all the above values passed to
    it. *)
let m = make_machine init_state f_states sigma delta init_tape p_a p_q


