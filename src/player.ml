open Pokemon

type player = { team : pokemon list; first_pokemon : pokemon option }
(** A player has a team and a first pokemon to send out *)

(** Creates a new player with an empty team*)
let new_player = { team = []; first_pokemon = None }

(** Add a new pokemon to the players team*)
let add_team pokemon player =
  { team = pokemon :: player.team; first_pokemon = Some pokemon }
