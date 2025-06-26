open Examples

let () = print_endline "[ 5-state Busy Beaver ]\n"
let () = Tm.Machine.execute_moving_head Bb5.m 5300 2650

