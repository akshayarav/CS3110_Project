open Pokedex

(* Helper function to create Pokémon with specified level *)
let create_pokemon base_pokemon level =
  Pokemon.create base_pokemon level

(* Elite Four Member 1 - Specializes in Grass-Type *)
let member1 = Trainer.create_trainer
  "Allen"
  [
    create_pokemon base_venusaur 50;   (* Venusaur *)
    create_pokemon base_ivysaur 45;    (* Ivysaur *)
    create_pokemon base_bulbasaur 40;  (* Bulbasaur *)
    create_pokemon base_tangela 46;    (* Tangela *)
    create_pokemon base_victreebel 48; (* Victreebel *)
    create_pokemon base_exeggutor 50;  (* Exeggutor *)
  ]
  (Some (create_pokemon base_venusaur 50))

(* Elite Four Member 2 - Specializes in Fire-Type *)
let member2 = Trainer.create_trainer
  "Jonny"
  [
    create_pokemon base_charizard 50;    (* Charizard *)
    create_pokemon base_arcanine 53;     (* Arcanine *)
    create_pokemon base_ninetales 48;    (* Ninetales *)
    create_pokemon base_rapidash 46;     (* Rapidash *)
    create_pokemon base_magmar 47;       (* Magmar *)
    create_pokemon base_flareon 45;      (* Flareon *)
  ]
  (Some (create_pokemon base_charizard 50))

(* Elite Four Member 3 - Specializes in Water-Type *)
let member3 = Trainer.create_trainer
  "Ryan"
  [
    create_pokemon base_blastoise 50;   (* Blastoise *)
    create_pokemon base_gyarados 53;    (* Gyarados *)
    create_pokemon base_vaporeon 47;    (* Vaporeon *)
    create_pokemon base_lapras 48;      (* Lapras *)
    create_pokemon base_tentacruel 46;  (* Tentacruel *)
    create_pokemon base_golduck 45;     (* Golduck *)
  ]
  (Some (create_pokemon base_blastoise 50))

(* Elite Four Member 4 - Specializes in a Variety of Types *)
let member4 = Trainer.create_trainer
  "Blake"
  [
    create_pokemon base_pidgeot 50;      (* Pidgeot *)
    create_pokemon base_fearow 48;       (* Fearow *)
    create_pokemon base_aerodactyl 53;   (* Aerodactyl *)
    create_pokemon base_charizard 50;    (* Charizard - Flying/Fire Type *)
    create_pokemon base_dragonite 55;    (* Dragonite - Flying/Dragon Type *)
    create_pokemon base_gyarados 52;     (* Gyarados - Flying/Water Type *)
  ]
  (Some (create_pokemon base_pidgeot 50))

let elite_four = [| member1; member2; member3; member4 |]