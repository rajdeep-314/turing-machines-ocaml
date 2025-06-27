open Examples

let () = print_endline "[ Turing's very first example ]\n"
let () = Tm.Machine.execute_moving_head First.m ~limit:(Some 20) 22 2

