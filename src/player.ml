open Pokemon

type player = { team : pokemon list; first_pokemon : pokemon option }

let new_player = { team = []; first_pokemon = None }

let add_team pokemon player =
  { team = pokemon :: player.team; first_pokemon = Some pokemon }
