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


let rec fix_length l n =
    if n <= 0 then []
    else
        match l with
        | [] -> None :: fix_length [] (n - 1)
        | x :: xs -> x :: fix_length xs (n - 1)

