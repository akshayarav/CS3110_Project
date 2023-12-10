open Pokemon

(** This module contains definitions and functionalities related to Pokémon, their evolutions, and interactions with the game world in the Pokémon game. *)

val json_to_base_pokemon : Yojson.Basic.t -> base_pokemon
(** [json_to_base_pokemon json] converts a JSON object [json] to a base_pokemon.
    The function parses the JSON for Pokémon's name, type, HP, moves, learnable
    moves, and sets evolution as None. *)

val add_evolution_details : base_pokemon -> base_pokemon list -> Yojson.Basic.t -> base_pokemon
(** [add_evolution_details base_pokemon all_pokemon json] adds evolution details
    to a [base_pokemon] using the list of all Pokémon [all_pokemon] and a JSON object [json]. *)

val pokemons_from_json : string -> base_pokemon list
(** [pokemons_from_json file] reads a JSON file [file] and returns a list of
    base Pokémon with their respective evolution details. *)

val all_pokemon : base_pokemon list
(** [all_pokemon] is a list of all Pokémon loaded from the "src/data/pokedex.json" file. *)

val find_pokemon_by_name : string -> base_pokemon
(** [find_pokemon_by_name name] finds a Pokémon by its name [name] in the list of all Pokémon.
    Raises: [Not_found] if no Pokémon with the given name is found. *)

val starters_base : base_pokemon list
(** [starters_base] is a list of starter Pokémon, including Bulbasaur, Charmander, and Squirtle. *)

val wild_pokemon_base : base_pokemon list
(** [wild_pokemon_base] is a list of wild Pokémon encountered in the game. *)

val reward_pokemon_base : base_pokemon list
(** [reward_pokemon_base] is a list of Pokémon that are obtained as rewards in the game. *)

val legendary_pokemon_base : base_pokemon list
(** [legendary_pokemon_base] is a list of legendary Pokémon available in the game. *)
