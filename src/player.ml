open Pokemon

type player = { team : pokemon list; current_pokemon : pokemon option ; coins : int}
(** A player has a team, a first pokemon to send out, and the current pokemon in battle *)

(** Creates a new player with an empty team*)
let new_player = { team = []; current_pokemon = None ; coins = 10}

(** Add a new pokemon to the player's team *)
let add_team pokemon player =
  match player.team with
  | [] -> { team = [pokemon]; current_pokemon = Some pokemon; coins = player.coins }
  | _ -> { player with team = pokemon :: player.team }

(** Adjusts the player's coins *)
let adjust_coins amt player =
  let new_coins = player.coins + amt in
  match new_coins with
  | num when num >= 0 -> { player with coins = new_coins }
  | _ -> { player with coins = 0 }

(** Displays the player's stats *)
let player_to_string player =
  let rec pokemon_list_to_string pokemons =
    match pokemons with
    | [] -> ""
    | [pokemon] -> Pokemon.to_string pokemon
    | pokemon :: rest ->
        Pokemon.to_string pokemon ^ ", " ^ pokemon_list_to_string rest
  in
  "Player's team:\n"
  ^ pokemon_list_to_string player.team
  ^
  match player.current_pokemon with
  | None -> "\nNo current pokemon in battle"
  | Some current_pokemon ->
      "\nCurrent pokemon to be used in battle:\n"
      ^ Pokemon.to_string current_pokemon
  ^ "\nCoins: " ^ string_of_int player.coins