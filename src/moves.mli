open Pokemon

(** This module contains definitions and functionalities related to moves in the Pokémon game. *)

val json_to_move : Yojson.Basic.t -> move
(** [json_to_move json] converts a JSON object [json] to a move.
    Raises: [Failure "Invalid JSON"] if the JSON does not represent a valid move. *)

val moves_from_json : string -> move list
(** [moves_from_json json_str] reads a JSON string [json_str] and returns a list of moves.
    Raises: [Failure "Invalid JSON"] if the JSON string is not valid. *)

val all_moves : move list
(** [all_moves] is a list of all moves available in the game. *)

val find_move_by_name : string -> move list -> move
(** [find_move_by_name name move_list] finds a move by its name [name] in the list [move_list].
    Raises: [Not_found] if no move with the given name is found. *)

val string_to_move : string -> move
(** [string_to_move str] converts a string [str] to a move.
    The string is expected to contain move details in a specific format.
    Raises: [Failure "Invalid format"] if the string is not in the expected format. *)