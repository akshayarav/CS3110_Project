open Moves
open Pokemon
open Yojson.Basic.Util

(* Function to convert a JSON object to a base_pokemon (without evolution) *)
let json_to_base_pokemon json =
  {
    name = json |> member "name" |> to_string;
    ptype = json |> member "ptype" |> to_string |> Pokemon.string_to_ptype;
    max_hp = json |> member "max_hp" |> to_int;
    moves = json |> member "moves" |> to_list |> List.map to_string |> List.map string_to_move;
    learnable_moves = json |> member "learnable_moves" |> to_list |> List.map (fun jm -> (jm |> member "level" |> to_int, jm |> member "move" |> to_string |> string_to_move));
    evolution = None
  }

(* Function to add evolution details to a base_pokemon *)
let add_evolution_details base_pokemon all_pokemon json =
  match json |> member "evolution" with
  | `Null -> base_pokemon
  | ev ->
    let evolved_name = ev |> member "evolves_into" |> to_string in
    let evolved_level = ev |> member "level" |> to_int in
    let evolved_form = List.find (fun p -> p.name = evolved_name) all_pokemon in
    { base_pokemon with evolution = Some (evolved_level, evolved_form) }

(* Function to read and parse the JSON file *)
let pokemons_from_json file =
  let json_list = Yojson.Basic.from_file file |> to_list in
  let base_pokemon_list = List.map json_to_base_pokemon json_list in
  List.map2 (fun base_pokemon json -> add_evolution_details base_pokemon base_pokemon_list json) base_pokemon_list json_list

(* Load all Pokémon from JSON *)
let all_pokemon = pokemons_from_json "src/data/pokedex.json"

(* Function to find a Pokemon by name *)
let find_pokemon_by_name name =
  List.find (fun pokemon -> pokemon.name = name) all_pokemon

let starters_base = List.map find_pokemon_by_name ["Bulbasaur"; "Charmander"; "Squirtle"; "ALLEN TANG"]

let wild_pokemon_base = List.map find_pokemon_by_name
  ["Golduck"; "Jigglypuff"; "Psyduck"; "Pikachu"; "Pidgey"; "Rattata"; "Spearow"]

let reward_pokemon_base = List.map find_pokemon_by_name
  ["Pidgeot"; "Raticate"; "Fearow"; "Raichu"; "Wigglytuff"; "Sandslash"; "Gyarados";
   "Alakazam"; "Tangela"; "Victreebel"; "Exeggutor"; "Rapidash"; "Magmar";
   "Flareon"; "Vaporeon"; "Tentacruel"; "Persian"; "Magneton"; "Electrode";
   "Dugtrio"; "Marowak"; "Rhydon"; "Parasect"; "Venomoth"; "Butterfree";
   "Caterpie"; "Beedrill"]

let legendary_pokemon_base = List.map find_pokemon_by_name
  ["Mewtwo"; "Lugia"; "Moltres"; "Articuno"; "Zapdos"; "Rayquaza"; "Groudon"; "Kyogre"; "Ho-Oh"]