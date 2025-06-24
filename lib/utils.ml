(*
    utils.ml
*)


let rec opt_list_list_mem ls = function
    | [] -> true
    | x :: xs ->
            match x with
            | None -> opt_list_list_mem ls xs
            | Some v ->
                    List.mem v ls && opt_list_list_mem ls xs

let head_and_tail = function
    | [] -> (None, [])
    | x :: xs -> (x, xs)

