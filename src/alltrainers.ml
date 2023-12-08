(* open Pokedex
open Trainer

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
  (create_pokemon base_venusaur 50)

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
  (create_pokemon base_charizard 50)

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
  (create_pokemon base_blastoise 50)

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
  (create_pokemon base_pidgeot 50)

let elite_four = [| member1; member2; member3; member4 |]

(* Regular Trainer 1 - Specializes in Normal-Type Pokémon *)
let trainer1 = Trainer.create_trainer
  "Lucy"
  [
    create_pokemon base_pidgey 20;       (* Pidgey *)
    create_pokemon base_rattata 22;      (* Rattata *)
    create_pokemon base_jigglypuff 24;   (* Jigglypuff *)
    create_pokemon base_meowth 23;       (* Meowth *)
    create_pokemon base_eevee 25;        (* Eevee *)
  ]
  (create_pokemon base_pidgey 20)

(* Regular Trainer 2 - Specializes in Electric-Type Pokémon *)
let trainer2 = Trainer.create_trainer
  "Max"
  [
    create_pokemon base_pikachu 28;      (* Pikachu *)
    create_pokemon base_magnemite 26;    (* Magnemite *)
    create_pokemon base_voltorb 27;      (* Voltorb *)
    create_pokemon base_electabuzz 29;   (* Electabuzz *)
  ]
  (create_pokemon base_pikachu 28)

(* Regular Trainer 3 - Specializes in Ground-Type Pokémon *)
let trainer3 = Trainer.create_trainer
  "Sandra"
  [
    create_pokemon base_sandshrew 30;    (* Sandshrew *)
    create_pokemon base_diglett 32;      (* Diglett *)
    create_pokemon base_cubone 31;       (* Cubone *)
    create_pokemon base_ryhorn 33;       (* Rhyhorn *)
  ]
  (create_pokemon base_sandshrew 30)

(* Regular Trainer 4 - Specializes in Bug-Type Pokémon *)
let trainer4 = Trainer.create_trainer
  "Ethan"
  [
    create_pokemon base_caterpie 15;     (* Caterpie *)
    create_pokemon base_weedle 16;       (* Weedle *)
    create_pokemon base_paras 18;        (* Paras *)
    create_pokemon base_venonat 19;      (* Venonat *)
    create_pokemon base_butterfree 20;   (* Butterfree *)
  ]
  (create_pokemon base_caterpie 15)

let regular_trainers = [| trainer1; trainer2; trainer3; trainer4 |] *)