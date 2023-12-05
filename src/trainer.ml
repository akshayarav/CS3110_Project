open Pokemon
open Pokedex

type trainer = {
  name : string;
  team : pokemon list;
  current_pokemon : pokemon;
}

(* Base trainer type *)
type base_trainer = {
  base_name : string;
  base_team : base_pokemon list;
}

(* Function to create a new trainer from a base trainer *)
let create_trainer base_trainer level =
  let team = List.map (fun base_poke -> Pokemon.create base_poke level) base_trainer.base_team in
  {
    name = base_trainer.base_name;
    team = team;
    current_pokemon = List.hd team;
  }

(* Base trainer for Elite Four Member 1 - Allen *)
let base_member1 = {
  base_name = "Allen";
  base_team = [base_venusaur; base_ivysaur; base_bulbasaur; base_tangela; base_victreebel; base_exeggutor];
}

(* Base trainer for Elite Four Member 2 - Jonny *)
let base_member2 = {
  base_name = "Jonny";
  base_team = [base_charizard; base_arcanine; base_ninetales; base_rapidash; base_magmar; base_flareon];
}

(* Base trainer for Elite Four Member 3 - Ryan *)
let base_member3 = {
  base_name = "Ryan";
  base_team = [base_blastoise; base_gyarados; base_vaporeon; base_lapras; base_tentacruel; base_golduck];
}

(* Base trainer for Elite Four Member 4 - Blake *)
let base_member4 = {
  base_name = "Blake";
  base_team = [base_pidgeot; base_fearow; base_aerodactyl; base_charizard; base_dragonite; base_gyarados];
}

(* Base trainer for Regular Trainer 1 - Lucy *)
let base_trainer1 = {
  base_name = "Lucy";
  base_team = [base_pidgey; base_rattata; base_jigglypuff; base_meowth; base_eevee];
}

(* Base trainer for Regular Trainer 2 - Max *)
let base_trainer2 = {
  base_name = "Max";
  base_team = [base_pikachu; base_magnemite; base_voltorb; base_electabuzz];
}

(* Base trainer for Regular Trainer 3 - Sandra *)
let base_trainer3 = {
  base_name = "Sandra";
  base_team = [base_sandshrew; base_diglett; base_cubone; base_ryhorn];
}

(* Base trainer for Regular Trainer 4 - Ethan *)
let base_trainer4 = {
  base_name = "Ethan";
  base_team = [base_caterpie; base_weedle; base_paras; base_venonat; base_butterfree];
}

(* Function to create an array of trainers from base trainers *)
let create_elite_four () = Array.map (fun base_trainer -> create_trainer base_trainer 50) [| base_member1; base_member2; base_member3; base_member4 |]

let create_regular_trainers () = Array.map (fun base_trainer -> create_trainer base_trainer 20) [| base_trainer1; base_trainer2; base_trainer3; base_trainer4 |]