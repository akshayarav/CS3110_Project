(** This module contains AI-related functionalities for the Pokémon game. *)

open Pokemon

val random_choice : 'a list -> 'a
(** [random_choice list] selects a random element from a non-empty list [list].
    Raises: [Invalid_argument] if [list] is empty. *)

val choose_move : pokemon -> move
(** [choose_move pokemon] selects a random move from the list of available moves 
    of a given [pokemon].
    Raises: [Failure "No available moves for this Pokemon."] if the Pokémon has no available moves. *)
