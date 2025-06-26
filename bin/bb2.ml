open Examples

let () = print_endline "[ 2-state Busy Beaver ]\n"
let () = Tm.Machine.execute_moving_head Bb2.m 4 3

