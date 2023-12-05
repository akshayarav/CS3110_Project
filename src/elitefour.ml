open Pokedex

(* Helper function to create Pokémon with specified level *)
let create_pokemon base_pokemon level =
  Pokemon.create base_pokemon level

(* Elite Four Member 1 - Specializes in Grass-Type *)
let venusaur_50 = create_pokemon base_venusaur 50
let member1 = Trainer.create_trainer
  "Allen"
  [
    venusaur_50; (* Level 50 Venusaur *)
    create_pokemon base_ivysaur 45;  (* Level 45 Ivysaur *)
    create_pokemon base_dragonite 53;
  ]
  (Some venusaur_50)  (* Current Pokemon is Venusaur *)

(* Elite Four Member 2 - Specializes in Fire-Type *)
let charizard_50 = create_pokemon base_charizard 50
let member2 = Trainer.create_trainer
  "Elite Member 2"
  [
    charizard_50; (* Level 50 Charizard *)
    create_pokemon base_charmeleon 45; (* Level 45 Charmeleon *)
    create_pokemon base_arcanine 53;
  ]
  (Some charizard_50)  (* Current Pokemon is Charizard *)

(* Elite Four Member 3 - Specializes in Water-Type *)
let blastoise_50 = create_pokemon base_blastoise 50
let member3 = Trainer.create_trainer
  "Elite Member 3"
  [
    blastoise_50; (* Level 50 Blastoise *)
    create_pokemon base_wartortle 45;
    create_pokemon base_gyarados 53;
    (* Add more Water-Type Pokémon *)
  ]
  (Some blastoise_50)  (* Current Pokemon is Blastoise *)

(* Elite Four Member 4 - Specializes in a Variety of Types *)
let pidgeot_50 = create_pokemon base_pidgeot 50
let member4 = Trainer.create_trainer
  "Elite Member 4"
  [
    pidgeot_50;     (* Level 50 Pidgeot *)
    create_pokemon base_raticate 45;    (* Level 45 Raticate *)
    create_pokemon base_sandslash 45;   (* Level 45 Sandslash *)
    create_pokemon base_golduck 45;     (* Level 45 Golduck *)
    create_pokemon base_alakazam 55;
  ]
  (Some pidgeot_50)  (* Current Pokemon is Pidgeot *)

let elite_four = [| member1; member2; member3; member4 |]