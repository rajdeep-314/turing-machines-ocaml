(*
    machine.ml
*)


open Utils


type 'a tape_t =
    Tape of 'a option list * 'a option * 'a option list

let make_tape l v r = Tape (l, v, r)


type action_t =
    | Left
    | Right
    | Nothing


type ('a, 'q) t =
    { q0 : 'q;
      f_states : 'q list ;
      sigma : 'a list ;
      delta : 'q -> 'a -> 'q * 'a * action_t ;
      tape : 'a tape_t }


let validate_tape (Tape (l, v, r)) ls =
    opt_list_list_mem ls [v] &&
    opt_list_list_mem ls l   &&
    opt_list_list_mem ls r


let make_machine q0 f_states sigma delta tape =
    if validate_tape tape sigma then
        failwith "Incompatible starting tape and \\Sigma values."
    else
        { q0 = q0 ;
          f_states = f_states ;
          sigma = sigma ;
          delta = delta ;
          tape = tape }


let move_head (Tape (l, v, r) as tp) = function
    | Nothing -> tp
    | Left ->
            let new_v, new_l = head_and_tail l in
            Tape (new_l, new_v, v :: r)
    | Right ->
            let new_v, new_r = head_and_tail r in
            Tape (v :: l, new_v, new_r)


