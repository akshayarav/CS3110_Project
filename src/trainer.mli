(** This module contains types and functions related to trainers in the Pokémon game. *)

open Pokemon

type trainer = { name : string; team : pokemon list; current_pokemon : pokemon }
(** Type representing a trainer in the game, with a name, a team of Pokémon, and the current Pokémon in battle. *)

type base_trainer = { base_name : string; base_team : base_pokemon list }
(** Type representing the base configuration of a trainer, used to create trainers with predefined characteristics. *)

val create_trainer : base_trainer -> int -> trainer
(** [create_trainer base_trainer level] creates a new trainer from a [base_trainer] with Pokémon at the given [level]. *)

val create_elite_four : unit -> trainer array
(** [create_elite_four ()] creates an array of trainers representing the Elite Four, each with a predefined team. *)

val create_regular_trainers : unit -> trainer array
(** [create_regular_trainers ()] creates an array of regular trainers, each with a predefined team. *)
