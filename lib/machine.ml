(*
    machine.ml
*)


open Utils


type 'a tape =
    Tape of 'a option list * 'a option * 'a option list

let make_tape l v r = Tape (l, v, r)

let tape_head (Tape (_, v, _)) = v


type action =
    | Left
    | Right
    | Nothing


type ('a, 'q) t =
    { state : 'q;
      f_states : 'q list ;
      delta : 'q -> 'a option -> 'q * 'a option * action ;
      tape : 'a tape ;
      printer_a : 'a -> unit ;
      printer_q : 'q -> unit }


let validate_tape (Tape (l, v, r)) ls =
    opt_list_list_mem ls [v] &&
    opt_list_list_mem ls l   &&
    opt_list_list_mem ls r


let make_machine q0 f_states sigma delta tape p_a p_q =
    if validate_tape tape sigma then
        { state = q0 ;
          f_states = f_states ;
          delta = delta ;
          tape = tape ;
          printer_a = p_a ;
          printer_q = p_q }
    else
        failwith "Incompatible starting tape and \\Sigma values."



(* Printing functions. *)

let print_symb m = function
    | None -> Printf.printf "."     (* Current placeholder for a blank cell. *)
    | Some v -> m.printer_a v

let print_symb_list m =
    List.iter (fun x -> print_symb m x; Printf.printf " | ")


let print_head m =
    print_symb m (tape_head m.tape)

let print_tape m =
    let (Tape (l, v, r)) = m.tape in
    let () = Printf.printf "... | " in
    let () = print_symb_list m (List.rev l) in
    let () = Printf.printf "\027[1;36;48;5;53m" in
    let () = print_symb m v in
    let () = Printf.printf "\027[0m | " in
    let () = print_symb_list m r in
    Printf.printf "..."


let print_tape_extended m n =
    let (Tape (l, v, r)) = m.tape in
    let l_list = List.rev (fix_length l n) in
    let r_list = fix_length r n in
    let () = Printf.printf "| " in
    let () = print_symb_list m l_list in
    let () = Printf.printf "\027[1;36;48;5;53m" in
    let () = print_symb m v in
    let () = Printf.printf "\027[0m | " in
    print_symb_list m r_list


(* let print_tape_pretty m n1 n2 = *)
(*     if n1 <= 0 then () *)
(*     else *)
(*         let () = Printf.printf "| " in *)
(*         let (Tape (l, v, r)) = m.tape in *)
(*         let l_len = max 0 (min (n2 - 1) n1) in *)
(*         let r_len = max 0 (min (n1 - n2) n1) in *)
(*         let l_list = List.rev (fix_length l l_len) in *)
(*         let r_list = fix_length r r_len in *)
(*         (* If the head is out of bounds on the left. *) *)
(*         if n2 <= 0 then *)
(*             print_symb_list m r_list *)
(*         (* If the head is out of bounds on the right. *) *)
(*         else if n2 > n1 then *)
(*             print_symb_list m l_list *)
(*         else *)
(*             let () = print_symb_list m l_list in *)
(*             let () = Printf.printf "\027[1;36;48;5;53m" in *)
(*             let () = print_symb m v in *)
(*             let () = Printf.printf "\027[0m | " in *)
(*             print_symb_list m r_list *)


(* For now, only accepts 1 <= n1 and 1 <= n2 <= n1. *)
let print_tape_pretty m n1 n2 =
    if 1 > n1 then
        failwith "Invalid argument (n1) to print_tape_pretty. n1 must be at least 1."
    else if 1 > n2 || n2 > n1 then
        failwith "Invalid argument (n2) to print_tape_pretty. 1 <= n2 <= n1 must hold."
    else
    let () = Printf.printf "| " in
    let (Tape (l, v, r)) = m.tape in
    let l_len = max 0 (min (n2 - 1) n1) in
    let r_len = max 0 (min (n1 - n2) n1) in
    let l_list = List.rev (fix_length l l_len) in
    let r_list = fix_length r r_len in
    let () = print_symb_list m l_list in
    let () = Printf.printf "\027[1;36;48;5;53m" in
    let () = print_symb m v in
    let () = Printf.printf "\027[0m | " in
    print_symb_list m r_list


let print_current_state m =
    m.printer_q m.state

let print_state_list m ls =
    let () = Printf.printf "| " in
    let () = List.iter (fun x -> m.printer_q x; Printf.printf " | ") ls in
    Printf.printf "|"


let print_f_states m =
    print_state_list m m.f_states


let print_machine m =
    let () = Printf.printf "Head: " in
    let () = print_head m in
    let () = Printf.printf "\nTape: " in
    let () = print_tape m in
    let () = Printf.printf "\nCurrent state: " in
    print_current_state m


(* Operation functions. *)

let move_head (Tape (l, v, r) as tp) = function
    | Nothing -> tp
    | Left ->
            let new_v, new_l = head_and_tail l in
            Tape (new_l, new_v, v :: r)
    | Right ->
            let new_v, new_r = head_and_tail r in
            Tape (v :: l, new_v, new_r)


let run m =
    let Tape (l, v, r) = m.tape in
    let new_state, new_v, act = m.delta m.state v in
    let new_tape = move_head (Tape (l, new_v, r)) act in
    { state = new_state ;
      f_states = m.f_states ;
      delta = m.delta ;
      tape = new_tape ;
      printer_a = m.printer_a ;
      printer_q = m.printer_q }


let rec run_till_halt m =
    if List.mem m.state m.f_states then m
    else run_till_halt (run m)




(* Helper function for execute, to keep track of the stage number. *)
let rec execute_h m sn =
    let () = Printf.printf "Stage number %d" sn in
    let () = Printf.printf "\n------------------\n" in
    let () = print_machine m in
    let () = print_endline "\n\n" in
    if List.mem m.state m.f_states then
        Printf.printf "HALTED!\n"
    else
        execute_h (run m) (sn + 1)

let execute m =
    execute_h m 1


let rec execute_moving_tape_h m n sn =
    let () = Printf.printf "%d:\t\t" sn in
    let () = print_tape_extended m n in
    let () = Printf.printf "\t\t[ " in
    let () = print_current_state m in
    let () = Printf.printf " ]" in
    let () = print_endline "" in
    if List.mem m.state m.f_states then ()
    else
        execute_moving_tape_h (run m) n (sn + 1)

let execute_moving_tape m n =
    execute_moving_tape_h m n 1


let head_offset_delta = function
    | Left -> -1
    | Right -> 1
    | Nothing -> 0


let rec execute_moving_head_h m n1 n2 sn =
    let () = Printf.printf "%d:\t\t" sn in
    let () = print_tape_pretty m n1 n2 in
    let () = Printf.printf "\t\t[ " in
    let () = print_current_state m in
    let () = Printf.printf " ]" in
    let () = print_endline "" in
    if List.mem m.state m.f_states then ()
    else
        let Tape (l, v, r) = m.tape in
        let new_state, new_v, act = m.delta m.state v in
        let new_tape = move_head (Tape (l, new_v, r)) act in
        let new_m = 
            { state = new_state ;
              f_states = m.f_states ;
              delta = m.delta ;
              tape = new_tape ;
              printer_a = m.printer_a ;
              printer_q = m.printer_q } in
        let new_n2 = n2 + head_offset_delta act in
        execute_moving_head_h new_m n1 new_n2 (sn + 1)

let execute_moving_head m n1 n2 =
    execute_moving_head_h m n1 n2 1


let rec execute_fast_h m sn =
    if List.mem m.state m.f_states then
        let () = Printf.printf "%d:\n" sn in
        let () = print_machine m in
        print_endline ""
    else
        execute_fast_h (run m) (sn + 1)

let execute_fast m =
    execute_fast_h m 0

