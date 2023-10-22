open Pokemon

type player = {
  team : pokemon list;
  current_pokemon : pokemon option;
}
(** A player has a team, a first pokemon to send out, and the current pokemon in battle *)

(** Creates a new player with an empty team*)
let new_player = { team = []; current_pokemon = None }

(** Add a new pokemon to the player's team*)
let add_team pokemon player =
  match player.team with
  | [] -> { team = [pokemon]; current_pokemon = Some pokemon }
  | _ -> { player with team = pokemon :: player.team }