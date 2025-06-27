(** Turing's very first example. *)


open Tm.Machine


type state =
    | B | C | E | F

let init_state = B
let f_states = []


type alphabet =
    | Zero
    | One

let z = Some Zero
let o = Some One

let sigma = []
let init_tape = empty_tape ()


let p_a = function
    | Zero -> print_string "0"
    | One -> print_string "1"

let p_q = function
    | B -> print_string "B"
    | C -> print_string "C"
    | E -> print_string "E"
    | F -> print_string "F"


let delta_B = function
    | None -> (C, z, Right)
    | _ -> (B, None, Nothing)

let delta_C = function
    | None -> (E, None, Right)
    | _ -> (B, None, Nothing)

let delta_E = function
    | None -> (F, o, Right)
    | _ -> (B, None, Nothing)

let delta_F = function
    | None -> (B, None, Right)
    | _ -> (B, None, Nothing)


let delta q s =
    match q with
    | B -> delta_B s
    | C -> delta_C s
    | E -> delta_E s
    | F -> delta_F s


let m = make_machine init_state f_states sigma delta init_tape p_a p_q

