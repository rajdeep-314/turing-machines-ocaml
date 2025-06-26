open Examples

let () = print_endline "[ 4-state Busy Beaver ]\n"
let () = Tm.Machine.execute_moving_head Bb4.m 18 13

