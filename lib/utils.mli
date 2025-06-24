(** General utility functions, used across other modules in the library. *)


(** For lists [l1 : 'a list] and [l2 : 'a option list], gives whether
    all [Some v] entries in [l2] are such that [v] is in [l1]. *)
val opt_list_list_mem : 'a list -> 'a option list -> bool


val head_and_tail : 'a option list -> 'a option * 'a option list

