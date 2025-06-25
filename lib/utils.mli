(** General utility functions, used across other modules in the library. *)


(** For lists [l1 : 'a list] and [l2 : 'a option list], gives whether
    all [Some v] entries in [l2] are such that [v] is in [l1]. *)
val opt_list_list_mem : 'a list -> 'a option list -> bool


(** Gives the head and tail for a list with option values. *)
val head_and_tail : 'a option list -> 'a option * 'a option list


(** Fixes the length of an option list to a particular length, either
    concatenating it or extending it with [None] entries to meet the length
    requirements. *)
val fix_length : 'a option list -> int -> 'a option list

