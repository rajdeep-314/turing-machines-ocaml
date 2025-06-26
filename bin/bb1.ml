open Examples

let () = print_endline "[ 1-state Busy Beaver ]\n"
let () = Tm.Machine.execute_moving_head Bb1.m 3 2

