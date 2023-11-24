open Moves

(* Evolutions of Bulbasaur *)
let base_ivysaur =
  {
    name = "Ivysaur";
    ptype = Grass;
    max_hp = 60;
    (* Example stats *)
    moves = [ tackle; growl; leech_seed; vine_whip ];
    (* Initial moves *)
    learnable_moves = [ (20, razor_leaf) ];
    (* Example learnable move *)
    evolution = None;
    (* Ivysaur does not evolve further in this implementation *)
  }

let base_venusaur =
  {
    name = "Venusaur";
    ptype = Grass;
    max_hp = 80;
    (* Example stats *)
    moves = [ tackle; growl; leech_seed; vine_whip ];
    (* Initial moves *)
    learnable_moves = [ (50, solar_beam) ];
    (* Example learnable move *)
    evolution = None;
  }

let base_bulbasaur =
  {
    name = "Bulbasaur";
    ptype = Grass;
    max_hp = 45;
    moves = [ tackle; growl; leech_seed; vine_whip ];
    learnable_moves = [ (8, razor_leaf) ];
    (* Example learnable move *)
    evolution = Some (16, base_ivysaur);
    (* Evolves into Ivysaur at level 16 *)
  }

(* Evolutions of Charmander *)
let base_charizard =
  {
    name = "Charizard";
    ptype = Fire;
    max_hp = 78;
    moves = [ scratch; growl; ember ];
    learnable_moves = [ (46, fire_blast) ];
    evolution = None;
  }

let base_charmeleon =
  {
    name = "Charmeleon";
    ptype = Fire;
    max_hp = 58;
    moves = [ scratch; growl; ember ];
    learnable_moves = [ (24, flame_thrower) ];
    evolution = Some (36, base_charizard);
    (* Evolves into Charizard at level 36 *)
  }

let base_charmander =
  {
    name = "Charmander";
    ptype = Fire;
    max_hp = 39;
    moves = [ scratch; growl; ember ];
    learnable_moves = [ (12, flame_thrower) ];
    evolution = Some (16, base_charmeleon);
    (* Evolves into Charmeleon at level 16 *)
  }

(* Evolutions of Squirtle *)
let base_blastoise =
  {
    name = "Blastoise";
    ptype = Water;
    max_hp = 79;
    moves = [ tackle; tail_whip; water_gun ];
    learnable_moves = [ (45, hydro_pump) ];
    evolution = None;
  }

let base_wartortle =
  {
    name = "Wartortle";
    ptype = Water;
    max_hp = 59;
    moves = [ tackle; tail_whip; water_gun ];
    learnable_moves = [ (25, water_pulse) ];
    evolution = Some (36, base_blastoise);
    (* Evolves into Blastoise at level 36 *)
  }

let base_squirtle =
  {
    name = "Squirtle";
    ptype = Water;
    max_hp = 44;
    moves = [ tackle; tail_whip; water_gun ];
    learnable_moves = [ (13, water_pulse) ];
    evolution = Some (16, base_wartortle);
    (* Evolves into Wartortle at level 16 *)
  }

(* Evolutions of Pidgey *)

let base_pidgeot =
  {
    name = "Pidgeot";
    ptype = Normal;
    max_hp = 63;
    (* Example stats *)
    moves = [ quick_attack; gust ];
    learnable_moves = [ (40, hurricane) ];
    (* Example learnable move *)
    evolution = None;
  }

let base_pidgeotto =
  {
    name = "Pidgeotto";
    ptype = Normal;
    max_hp = 49;
    (* Example stats *)
    moves = [ quick_attack; gust ];
    learnable_moves = [ (22, wing_attack) ];
    (* Example learnable move *)
    evolution = Some (36, base_pidgeot);
    (* Evolves into Pidgeot at level 36 *)
  }

(* Updated Pidgey with learnable moves and evolution *)
let base_pidgey =
  {
    name = "Pidgey";
    ptype = Normal;
    max_hp = 31;
    moves = [ quick_attack; gust ];
    learnable_moves = [ (9, wing_attack) ];
    (* Example learnable move *)
    evolution = Some (18, base_pidgeotto);
    (* Evolves into Pidgeotto at level 18 *)
  }

(* Evolution of Rattata *)
let base_raticate =
  {
    name = "Raticate";
    ptype = Normal;
    max_hp = 55;
    (* Example stats *)
    moves = [ tackle; quick_attack ];
    learnable_moves = [ (20, hyper_fang) ];
    (* Example learnable move *)
    evolution = None;
  }

(* Updated Rattata with learnable moves and evolution *)
let base_rattata =
  {
    name = "Rattata";
    ptype = Normal;
    max_hp = 31;
    moves = [ tackle; quick_attack ];
    learnable_moves = [ (14, hyper_fang) ];
    (* Example learnable move *)
    evolution = Some (20, base_raticate);
    (* Evolves into Raticate at level 20 *)
  }

(* Evolution of Spearow *)
let base_fearow =
  {
    name = "Fearow";
    ptype = Normal;
    max_hp = 65;
    (* Example stats *)
    moves = [ peck ];
    learnable_moves = [ (25, drill_peck) ];
    (* Example learnable move *)
    evolution = None;
  }

(* Updated Spearow with learnable moves and evolution *)
let base_spearow =
  {
    name = "Spearow";
    ptype = Normal;
    max_hp = 31;
    moves = [ peck ];
    learnable_moves = [ (20, drill_peck) ];
    (* Example learnable move *)
    evolution = Some (20, base_fearow);
    (* Evolves into Fearow at level 20 *)
  }

let starters_base = [ base_bulbasaur; base_charmander; base_squirtle ]
let wild_pokemon_base = [ base_pidgey; base_rattata; base_spearow ]
