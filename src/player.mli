(** This module contains the definition and functionalities related to the player in the Pokémon game. *)

open Pokemon

type player = {
  team : pokemon list;
  current_pokemon : pokemon option;
  coins : int;
}
(** Type representing a player in the game.
    It includes the player's team of Pokémon, the current Pokémon in battle, and the number of coins the player has. *)

val get_team : player -> pokemon list
(** [get_team p] returns the team of Pokémon of player [p]. *)

val get_current_pokemon : player -> pokemon option
(** [get_current_pokemon p] returns the current Pokémon in battle for player [p], if any. *)

val new_player : player
(** [new_player] creates a new player with an empty team and a default number of coins. *)

val add_team : pokemon -> player -> player * bool
(** [add_team new_pokemon player] tries to add [new_pokemon] to [player]'s team.
    Returns a tuple of the updated player and a boolean indicating success or failure.
    Raises: [Failure "Team full"] if the team already has 6 Pokémon. *)

val adjust_coins : int -> player -> player
(** [adjust_coins amt player] adjusts the coins of [player] by [amt].
    If the resulting number of coins is negative, it sets the coins to zero. *)

val player_to_string : player -> string
(** [player_to_string player] converts the player's stats to a string representation, including team and current Pokémon. *)

val update_pokemon : pokemon -> player -> player
(** [update_pokemon updated_pokemon player] updates the information of a specific Pokémon in the player's team.
    It also sets the updated Pokémon as the current Pokémon in battle. *)
