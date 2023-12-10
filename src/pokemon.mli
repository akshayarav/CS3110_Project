(** This module contains the types and functions for Pokémon and their interactions in the Pokémon game. *)

(** Type representing Pokémon types. *)
type ptype =
  | Normal
  | Fire
  | Water
  | Electric
  | Grass
  | Ice
  | Fighting
  | Poison
  | Ground
  | Flying
  | Psychic
  | Bug
  | Rock
  | Ghost
  | Dragon
  | Dark
  | Steel
  | Fairy

type move = { name : string; damage : int; m_ptype : ptype }
(** Type representing a Pokémon move. *)

type base_pokemon = {
  name : string;
  ptype : ptype;
  max_hp : int;
  moves : move list;
  learnable_moves : (int * move) list;
  evolution : (int * base_pokemon) option;
}
(** Type representing the base characteristics of a Pokémon. *)

type pokemon = {
  base : base_pokemon;
  mutable hp : int;
  mutable current_max_hp : int;
  mutable level : int;
  mutable xp : int * int;
  mutable feint : bool;
  mutable damage_modifier : float;
}
(** Type representing a Pokémon, including its base characteristics and mutable fields for game dynamics. *)

val get_type : pokemon -> ptype
(** [get_type p] returns the type of the given Pokémon [p]. *)

val ptype_to_string : ptype -> string
(** [ptype_to_string ptype] converts a Pokémon type to its string representation. *)

val string_to_ptype : string -> ptype
(** [string_to_ptype str] converts a string representation of a Pokémon type
    to its corresponding [ptype] variant. The string must match one of the
    recognized Pokémon type names exactly (e.g., "Normal", "Fire", "Water", etc.).
    The function is case-sensitive and will raise a [Failure] exception
    with the message "Unknown ptype" if the provided string does not correspond
    to any known Pokémon type. *)

val create : base_pokemon -> int -> pokemon
(** [create base level] creates a new Pokémon with specified base characteristics and level. *)

val create_random : base_pokemon -> int -> pokemon
(** [create_random base level] creates a new Pokémon with random HP, ensuring it's at least half of the max HP. *)

val copy_pokemon : pokemon -> pokemon
(** [copy_pokemon p] creates a deep copy of the given Pokémon [p]. *)

val attack : move -> pokemon -> pokemon -> unit
(** [attack move opponent_pokemon player_pokemon] performs an attack from [player_pokemon] to [opponent_pokemon] using [move],
    updating the opponent's HP and feint status. *)

val to_string : pokemon -> string
(** [to_string pokemon] converts the given Pokémon [pokemon] to its string representation, including its stats. *)

val name : pokemon -> string
(** [name pokemon] returns the name of the given Pokémon [pokemon]. *)

val max_level : int
(** The maximum level a Pokémon can achieve. *)

val level_up : pokemon -> pokemon
(** [level_up pokemon] levels up the given Pokémon [pokemon] if it has enough XP. *)

val add_xp : pokemon -> int -> pokemon
(** [add_xp pokemon xp_earned] adds XP to the given Pokémon [pokemon] and levels it up if necessary. *)

val calculate_xp_gained : int -> int
(** [calculate_xp_gained opponent_level] calculates the XP gained from defeating an opponent of the given level. *)

val check_new_moves : pokemon -> (int * move) list
(** [check_new_moves pokemon] checks for new moves that the Pokémon [pokemon] can learn at its current level. *)

val check_evolution : pokemon -> base_pokemon option
(** [check_evolution pokemon] checks if the Pokémon [pokemon] can evolve at its current level. *)

val evolve_pokemon : pokemon -> base_pokemon -> pokemon
(** [evolve_pokemon pokemon evolved_form] evolves the given Pokémon [pokemon] into [evolved_form]. *)

val learn_move : pokemon -> move -> int -> pokemon
(** [learn_move pokemon new_move move_to_replace] adds or replaces a move in the Pokémon's list of moves. *)
