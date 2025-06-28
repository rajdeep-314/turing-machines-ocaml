(** Turing's very first example. *)


open Tm.Machine

(** {1 Machine Description} *)

(** This is the machine that Turing gave as his very first example. For more info,
    check out {{:https://en.wikipedia.org/wiki/Turing_machine_examples#Turing's_very_first_example} Wikipedia}. *)


(** The machine has four states, namely [B], [C], [E] and [F]. *)
type state =
    | B | C | E | F

(* The initial state is [B]. *)
let init_state = B
(* There is no final state - the machine does not halt. *)
let f_states = []

(* There are two non-blank symbols that can be on the tape - [Zero] and [One]. *)
type alphabet =
    | Zero
    | One

(** Defined as [Some Zero]. *)
let z = Some Zero

(** Defined as [Some One]. *)
let o = Some One

(** No non-blank symbol is allowed on the input tape. *)
let sigma = []

(** The initial tape is empty. *)
let init_tape = empty_tape ()


(* Printer function for the symbols. *)
let p_a = function
    | Zero -> print_string "0"
    | One -> print_string "1"

(* Printer function for the states *)
let p_q = function
    | B -> print_string "B"
    | C -> print_string "C"
    | E -> print_string "E"
    | F -> print_string "F"


(** {1 Transition Functions} *)


(** {b {i NOTES:}}

    + [o/w] in a transition function's table denotes {i otherwise} and the
    corresponding row conveys the behavior for a symbol that doesn't match
    either of the cases above.
    + [x] in the table denotes that a particular operation for the row's case
    is not defined. In such cases, the OCaml functions give some arbitrary
    values.
    + The input tape being blank implies that these arbitrary values and [x]
    cases do not have any effect on the machine's execution. *)


(** Transition from [B].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   |   0   | Right |   C       |
       |    o/w |   x   |   x   |   x       |} *)
let delta_B = function
    | None -> (C, z, Right)
    | _ -> (B, None, Nothing)

(** Transition from [C].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   |   .   | Right |   E       |
       |    o/w |   x   |   x   |   x       |} *)
let delta_C = function
    | None -> (E, None, Right)
    | _ -> (B, None, Nothing)

(** Transition from [E].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   |   1   | Right |   F       |
       |    o/w |   x   |   x   |   x       |} *)
let delta_E = function
    | None -> (F, o, Right)
    | _ -> (B, None, Nothing)

(** Transition from [F].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   |   .   | Right |   B       |
       |    o/w |   x   |   x   |   x       |} *)
let delta_F = function
    | None -> (B, None, Right)
    | _ -> (B, None, Nothing)

(** The main transition function ({m \delta}). It combines the four "sub-delta"
    functions. *)
let delta q s =
    match q with
    | B -> delta_B s
    | C -> delta_C s
    | E -> delta_E s
    | F -> delta_F s


(** The Turing machine - just an application of {!Tm.Machine.make_machine} to
    the values defined above. *)
let m = make_machine init_state f_states sigma delta init_tape p_a p_q

