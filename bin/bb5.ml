open Examples

let () = print_endline "[ 5-state Busy Beaver ]\n"
let () = Tm.Machine.execute_fast Bb5.m

