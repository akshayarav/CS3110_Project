open Pokemon
open Printf

type player = {
  team : pokemon list;
  current_pokemon : pokemon option;
  coins : int;
}

(* Returns players team *)
let get_team (p : player) = p.team
let get_current_pokemon (p : player) = p.current_pokemon

(** A player has a team, a first pokemon to send out, and the current pokemon in battle *)

(** Creates a new player with an empty team*)
let new_player = { team = []; current_pokemon = None; coins = 10 }

(* Returns true if a Pokemon was successfully added or swapped in, false otherwise *)
let add_team new_pokemon player : player * bool =
  let team_size = List.length player.team in
  if team_size < 6 then
    ( {
        player with
        team = player.team @ [ new_pokemon ];
        current_pokemon =
          (match player.current_pokemon with
          | None -> Some new_pokemon
          | Some _ -> player.current_pokemon);
      },
      true )
  else failwith "Team full"

(** Adjusts the player's coins *)
let adjust_coins amt player =
  let new_coins = player.coins + amt in
  match new_coins with
  | num when num >= 0 -> { player with coins = new_coins }
  | _ -> { player with coins = 0 }

(** Displays the player's stats *)
let player_to_string player =
  let pokemon_list_to_string pokemons =
    let rec aux idx pokemons =
      match pokemons with
      | [] -> ""
      | pokemon :: rest ->
          sprintf "  %d. %s\n" idx (to_string pokemon) ^ aux (idx + 1) rest
    in
    aux 1 pokemons
  in

  let team_string =
    if player.team = [] then "No Pokémon in team."
    else "Team:\n" ^ pokemon_list_to_string player.team
  in

  let current_pokemon_string =
    match player.current_pokemon with
    | None -> "No current Pokémon in battle."
    | Some cp -> "Current Pokémon in battle:\n" ^ to_string cp
  in

  sprintf "Player's Stats:\n%s\n%s\nCoins: %d" team_string
    current_pokemon_string player.coins

let update_pokemon updated_pokemon player =
  let updated_team =
    List.map
      (fun pokemon ->
        if pokemon.base.name = updated_pokemon.base.name then updated_pokemon
        else pokemon)
      player.team
  in
  { player with team = updated_team; current_pokemon = Some updated_pokemon }
