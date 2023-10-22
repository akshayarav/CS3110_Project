open Pokemon

type player = { team : pokemon list; current_pokemon : pokemon option }
(** A player has a team, a first pokemon to send out, and the current pokemon in battle *)

(** Creates a new player with an empty team*)
let new_player = { team = []; current_pokemon = None }

(** Add a new pokemon to the player's team*)
let add_team pokemon player =
  match player.team with
  | [] -> { team = [ pokemon ]; current_pokemon = Some pokemon }
  | _ -> { player with team = pokemon :: player.team }

(** Displays the player's stats*)
let player_to_string player =
  let rec pokemon_list_to_string pokemons =
    match pokemons with
    | [] -> ""
    | [ pokemon ] -> Pokemon.to_string pokemon
    | pokemon :: rest ->
        Pokemon.to_string pokemon ^ ", " ^ pokemon_list_to_string rest
  in
  "Player's team: "
  ^ pokemon_list_to_string player.team
  ^
  match player.current_pokemon with
  | None -> "\nNo current pokemon in battle"
  | Some current_pokemon ->
      "\nCurrent pokemon to be used in battle: "
      ^ Pokemon.to_string current_pokemon
