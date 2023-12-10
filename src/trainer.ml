open Pokemon
open Pokedex

type trainer = { name : string; team : pokemon list; current_pokemon : pokemon }

(* Base trainer type *)
type base_trainer = { base_name : string; base_team : base_pokemon list }

(* Function to create a new trainer from a base trainer *)
let create_trainer base_trainer level =
  let team =
    List.map
      (fun base_poke -> Pokemon.create base_poke level)
      base_trainer.base_team
  in
  { name = base_trainer.base_name; team; current_pokemon = List.hd team }

(* Base trainer for Elite Four Member 1 - Allen *)
let base_member1 =
  {
    base_name = "Allen";
    base_team =
      List.map find_pokemon_by_name
        [
          "Venusaur";
          "Ivysaur";
          "Bulbasaur";
          "Tangela";
          "Victreebel";
          "Exeggutor";
        ];
  }

(* Base trainer for Elite Four Member 2 - Jonny *)
let base_member2 =
  {
    base_name = "Jonny";
    base_team =
      List.map find_pokemon_by_name
        [
          "Charizard"; "Arcanine"; "Ninetales"; "Rapidash"; "Magmar"; "Flareon";
        ];
  }

(* Base trainer for Elite Four Member 3 - Ryan *)
let base_member3 =
  {
    base_name = "Ryan";
    base_team =
      List.map find_pokemon_by_name
        [
          "Blastoise"; "Gyarados"; "Vaporeon"; "Lapras"; "Tentacruel"; "Golduck";
        ];
  }

(* Base trainer for Elite Four Member 4 - Blake *)
let base_member4 =
  {
    base_name = "Blake";
    base_team =
      List.map find_pokemon_by_name
        [
          "Pidgeot";
          "Fearow";
          "Aerodactyl";
          "Charizard";
          "Dragonite";
          "Gyarados";
        ];
  }

(* Base trainer for Regular Trainer 1 - Lucy *)
let base_trainer1 =
  {
    base_name = "Lucy";
    base_team =
      List.map find_pokemon_by_name
        [ "Pidgey"; "Rattata"; "Jigglypuff"; "Meowth"; "Eevee" ];
  }

(* Base trainer for Regular Trainer 2 - Max *)
let base_trainer2 =
  {
    base_name = "Max";
    base_team =
      List.map find_pokemon_by_name
        [ "Pikachu"; "Magnemite"; "Voltorb"; "Electabuzz" ];
  }

(* Base trainer for Regular Trainer 3 - Sandra *)
let base_trainer3 =
  {
    base_name = "Sandra";
    base_team =
      List.map find_pokemon_by_name
        [ "Sandshrew"; "Diglett"; "Cubone"; "Ryhorn" ];
  }

(* Base trainer for Regular Trainer 4 - Ethan *)
let base_trainer4 =
  {
    base_name = "Ethan";
    base_team =
      List.map find_pokemon_by_name
        [ "Caterpie"; "Weedle"; "Paras"; "Venonat"; "Butterfree" ];
  }

(* Function to create an array of trainers from base trainers *)
let create_elite_four () =
  Array.map
    (fun base_trainer -> create_trainer base_trainer 50)
    [| base_member1; base_member2; base_member3; base_member4 |]

let create_regular_trainers () =
  Array.map
    (fun base_trainer -> create_trainer base_trainer 20)
    [| base_trainer1; base_trainer2; base_trainer3; base_trainer4 |]
