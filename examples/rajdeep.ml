(** A machine that writes my name on the tape. *)


open Tm.Machine


(** {1 Types} *)

(** The machine has seven "actual" states - [S1] through [S7], one for each
    letter in my name. The final [H] state is the halt state. *)
type state =
    | S1 | S2 | S3 | S4 | S5 | S6 | S7 | H


(** The initial state is [S1]. *)
let init_state = S1

(** The only final state is [H]. *)
let f_states = [ H ]


(** The alphabet consists of one constructor per unique character in my name,
    so a total of six of them - [R], [A], [J], [D], [E] and [P]. *)
type alphabet =
    | R | A | J | D | E | P

(** For ease of writing the transition functions. *)
let r = Some R
let a = Some A
let j = Some J
let d = Some D
let e = Some E
let p = Some P

(** No symbols are allowed on the initial tape - it must be completely blank. *)
let sigma : alphabet list = []

(** The iniital tape is completely blank. *)
let initial_tape = empty_tape ()


(** Printer function for the alphabet. *)
let p_a = function
    | R -> print_string "R"
    | A -> print_string "A"
    | J -> print_string "J"
    | D -> print_string "D"
    | E -> print_string "E"
    | P -> print_string "P"

(** Printer function for the states. *)
let p_q = function
    | S1 -> print_string "S1"
    | S2 -> print_string "S2"
    | S3 -> print_string "S3"
    | S4 -> print_string "S4"
    | S5 -> print_string "S5"
    | S6 -> print_string "S6"
    | S7 -> print_string "S7"
    | H -> print_string "H"


(** {1 Transition Functions} *)

(** {i {b NOTES:}}
    + [o/w] in the tables below means {i otherwise} and is the corresponding row
    conveys what the transition would be for a symbol that doesn't match either
    of the cases above.
    + [.] refers to the blank symbol.
    + In each of the states [S1] through [S7], there's only one row in the
    transition table that does something actually meaningful, and that is the
    one that will be encountered due to the inital tape and state of the machine. *)

(** Transition from [S1].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   | R     | Right |   S2      |
       |  o/w   | .     | Nil   |   H       |} *)
let delta_S1 = function
    | None -> (S2, r, Right)
    | _ -> (H, None, Nothing)           (* Not used. *)

(** Transition from [S2].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   | A     | Right |   S3      |
       |  o/w   | .     | Nil   |   H       |} *)
let delta_S2 = function
    | None -> (S3, a, Right)
    | _ -> (H, None, Nothing)           (* Not used. *)

(** Transition from [S3].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   | J     | Right |   S4      |
       |  o/w   | .     | Nil   |   H       |} *)
let delta_S3 = function
    | None -> (S4, j, Right)
    | _ -> (H, None, Nothing)           (* Not used. *)

(** Transition from [S4].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   | D     | Right |   S5      |
       |  o/w   | .     | Nil   |   H       |} *)
let delta_S4 = function
    | None -> (S5, d, Right)
    | _ -> (H, None, Nothing)           (* Not used. *)

(** Transition from [S5].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   | E     | Right |   S6      |
       |  o/w   | .     | Nil   |   H       |} *)
let delta_S5 = function
    | None -> (S6, e, Right)
    | _ -> (H, None, Nothing)           (* Not used. *)

(** Transition from [S6].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   | E     | Right |   S7      |
       |  o/w   | .     | Nil   |   H       |} *)
let delta_S6 = function
    | None -> (S7, e, Right)
    | _ -> (H, None, Nothing)           (* Not used. *)

(** Transition from [S7].

    {t | Symbol | Write | Move  | New State |
       |--------|-------|-------|-----------|
       |    .   | P     | Right |   H       |
       |  o/w   | .     | Nil   |   H       |} *)
let delta_S7 = function
    | None -> (H, p, Right)
    | _ -> (H, None, Nothing)           (* Not used. *)

(** Exists only to make {!delta} define-able. *)
let delta_H _ = (H, None, Nothing)


(** The main transition function that combines {!delta_S1} through {!delta_S7}. *)
let delta q s =
    match q with
    | S1 -> delta_S1 s
    | S2 -> delta_S2 s
    | S3 -> delta_S3 s
    | S4 -> delta_S4 s
    | S5 -> delta_S5 s
    | S6 -> delta_S6 s
    | S7 -> delta_S7 s
    | H -> delta_H s


(** The Turing machine. *)
let m = make_machine init_state f_states sigma delta initial_tape p_a p_q

