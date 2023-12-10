(** This module contains functionalities for handling battles in the Pokémon game. *)

open Pokemon
open Trainer
open Player

val update_trainer_team : trainer -> pokemon list -> trainer
(** [update_trainer_team trainer new_team] updates the team of the given [trainer] with [new_team].
    Returns: a new trainer record with the updated team. *)

val wild_battle_loop: pokemon -> pokemon -> player -> bool
(** [wild_battle_loop player_pokemon opponent player] initiates a battle between the pokemon [player_pokemon] and [opponent].
  The battle_loop ends when either [opponent] feints or all of [player]'s pokemon feints. 
  Returns: if player_pokemon wins battle_loop true else false *)
  
val trainer_battle_loop: pokemon -> pokemon -> player -> trainer -> bool
(** [trainer_battle_loop player_pokemon opponent player] initiates a battle between the pokemon [player_pokemon] and [opponent].
  The battle_loop ends when either all of [player]'s pokemon feints or all of [trainer]'s pokemon feints. 
  Returns: if player_pokemon wins battle_loop true else false *)