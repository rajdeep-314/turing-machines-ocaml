(** Types for the "components" of a Turing machine and a type for the machines
    themselves, along with functions to work with the values of these types.

    The types are parametrized with other types, denoting the type of the
    alphabet and the type of the states. *)



(** Tape representation:

    If the symbols on the tape are values of type ['a], then the tape is
    represented by two lists, say {m L : 'a\,\mathrm{option}} and
    {m R : 'a\,\mathrm{option}}, and a value {m v : 'a} such that the head
    currently points to {m v}, and {m L} and {m R} denote how the tape is to
    the left and right of {m v} respectively.

    For example, consider the following contiguous section of a tape at some
    point in time:

        {m \dots, 1, \cdot, 1, \cdot, \overline 1, \cdot, \cdot, 1, 1, \dots}

    Assuming that {m \cdot} denotes the blank symbol, the head is at
    {m \overline 1} and the tape to the left and right of this region is
    completely blank, the representation would be:

        [v : int = 1]

        [L : int option list = [None; Some 1; None; Some 1]]

        [R : int option list = [None; None; Some 1; Some 1]] *)
type 'a tape_t =
    Tape of 'a option list * 'a option * 'a option list             (** {m L, v, R} *)

(** Helper function to construct a tape. *)
val make_tape : 'a option list -> 'a option -> 'a option list -> 'a tape_t


(** Type to capture what the head is supposed to do after a step - whether it
    should move one cell left, move one cell right, or do nothing. *)
type action_t =
    | Left
    | Right
    | Nothing


(** Type for a Turing machine with alphabets being values of the type ['a]
    and states being values of the type ['q]. This representation is inspired
    from the 7-tuple formalization mentioned on
    {{:https://en.wikipedia.org/wiki/Turing_machine#Formal_definition} Wikipedia},
    namely

    {m M = \langle Q, \Gamma, b, \Sigma, \delta, q_0, F \rangle}
    
    A slightly more detailed description follows.
        + ['a]: Values of this type are considered to be the alphabets that can
        be placed inside the tape's cells. This type is analogous to {m \Gamma}.
        As the tape representation uses ['a option] instead of ['a], there is no
        need for an explicit {m b}.
        + ['q]: Values of this type are considered to be the states, so this
        type is analogous to {m Q}.
        + [q0]: A value of ['q], denoting the initial state. This is {m q_0}.
        + [f_states]: Contains ['q] values which are considered toe be final
        states. This is analogous to {m F}.
        + [sigma]: Contains ['a] values which are considered to be valid in
        the inital tape. Analogous to {m \Sigma}.
        + [delta]: A curried function meant to take the current state and the
        alphabet at the head, to obtain the next state, the new symbol to be
        written at the head position, and the action that the head should
        perform after the writing, which is a value of `action_t`. Analogous to
        {m \delta:(Q\backslash F)\times\Gamma\to Q\times\Gamma\times\{L, R, N\}}.

    Catches/Differences:
        + No attention is paid to whether ['a] and ['q] are finite.
        + The Wikipedia definition doesn't include {m N} as an action, but this
        definition does, to denote that the head stays in place. *)
type ('a, 'q) t =
    { q0 : 'q ;
      f_states : 'q list ;
      sigma : 'a list ;
      delta : 'q -> 'a -> 'q * 'a * action_t ;
      tape : 'a tape_t }


(** Validates the input tape with {m \Sigma} - ensures that it doesn't have
    any non-blank symbols that are not in {m \Sigma}. *)
val validate_tape : 'a tape_t -> 'a list -> bool


(** Helper function to construct a Turing machine. *)
val make_machine :
    'q -> 'q list -> 'a list -> ('q -> 'a -> 'q * 'a * action_t) -> 'a tape_t
        -> ('a, 'q) t


val move_head : 'a tape_t -> action_t -> 'a tape_t

