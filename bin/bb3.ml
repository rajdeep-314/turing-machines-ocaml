open Examples

let () = print_endline "[ 3-state Busy Beaver ]\n"
let () = Tm.Machine.execute_moving_head Bb3.m 6 4

