(** This module contains functionalities for handling battles in the Pokémon game. *)

open Pokemon
open Trainer

val update_trainer_team : trainer -> pokemon list -> trainer
(** [update_trainer_team trainer new_team] updates the team of the given [trainer] with [new_team].
    Returns: a new trainer record with the updated team. *)
