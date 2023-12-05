open Moves
open Pokemon

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
    learnable_moves = [ (24, flamethrower) ];
    evolution = Some (36, base_charizard);
    (* Evolves into Charizard at level 36 *)
  }

let base_charmander =
  {
    name = "Charmander";
    ptype = Fire;
    max_hp = 39;
    moves = [ scratch; growl; ember ];
    learnable_moves = [ (12, flamethrower) ];
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

(* Pikachu *)
let base_raichu =
  {
    name = "Raichu";
    ptype = Electric;
    max_hp = 60;
    moves = [ thunder_shock; thunder_wave; quick_attack ];
    learnable_moves = [ (50, thunder) ];
    evolution = None;
  }

let base_pikachu =
  {
    name = "Pikachu";
    ptype = Electric;
    max_hp = 35;
    moves = [ thunder_shock; growl ];
    learnable_moves = [ (15, thunder_wave); (22, electro_ball) ];
    evolution = Some (30, base_raichu);
  }

(* Jigglypuff *)
let base_wigglytuff =
  {
    name = "Wigglytuff";
    ptype = Normal;
    max_hp = 70;
    moves = [ sing; double_slap; disable ];
    learnable_moves = [ (45, hyper_voice) ];
    evolution = None;
  }

let base_jigglypuff =
  {
    name = "Jigglypuff";
    ptype = Normal;
    max_hp = 45;
    moves = [ sing; pound ];
    learnable_moves = [ (18, double_slap); (24, rest) ];
    evolution = Some (36, base_wigglytuff);
  }

(* Psyduck *)
let base_golduck =
  {
    name = "Golduck";
    ptype = Water;
    max_hp = 80;
    moves = [ water_gun; confusion; disable ];
    learnable_moves = [ (52, hydro_pump) ];
    evolution = None;
  }

let base_psyduck =
  {
    name = "Psyduck";
    ptype = Water;
    max_hp = 50;
    moves = [ water_gun; tail_whip ];
    learnable_moves = [ (16, confusion); (23, fury_swipes) ];
    evolution = Some (33, base_golduck);
  }

let base_sandslash =
  {
    name = "Sandslash";
    ptype = Ground;
    max_hp = 85;
    moves = [ sand_attack ];
    learnable_moves = [ (45, dig) ];
    evolution = None;
  }

let base_sandshrew =
  {
    name = "Sandshrew";
    ptype = Ground;
    max_hp = 50;
    moves = [ sand_attack ];
    learnable_moves = [ (30, bulldoze) ];
    evolution = Some (35, base_sandslash);
  }

let base_gyarados =
  {
    name = "Gyarados";
    ptype = Water;
    max_hp = 95;
    moves = [ hydro_pump; bite; dragon_rage; leer ];
    learnable_moves = [ (55, hyper_beam) ];
    evolution = None;
  }

let base_dragonite =
  {
    name = "Dragonite";
    ptype = Flying;
    max_hp = 91;
    moves = [ wing_attack; thunder_wave; dragon_rage; slam ];
    learnable_moves = [ (60, hyper_beam) ];
    evolution = None;
  }

let base_alakazam =
  {
    name = "Alakazam";
    ptype = Psychic;
    max_hp = 55;
    moves = [ psybeam; reflect; recover; psychic ];
    learnable_moves = [ (45, future_sight) ];
    evolution = None;
  }

let base_arcanine =
  {
    name = "Arcanine";
    ptype = Fire;
    max_hp = 90;
    moves = [ fire_blast; bite; roar; take_down ];
    learnable_moves = [ (50, extreme_speed) ];
    evolution = None;
  }

(* Tangela *)
let base_tangela =
  {
    name = "Tangela";
    ptype = Grass;
    max_hp = 65;
    moves = [ vine_whip; leech_seed; solar_beam; sleep_powder ];
    learnable_moves = [ (40, razor_leaf) ];
    evolution = None;
  }

(* Victreebel *)
let base_victreebel =
  {
    name = "Victreebel";
    ptype = Grass;
    max_hp = 80;
    moves = [ razor_leaf; sleep_powder; solar_beam; leech_seed ];
    learnable_moves = [ (50, hyper_beam) ];
    evolution = None;
  }

(* Exeggutor *)
let base_exeggutor =
  {
    name = "Exeggutor";
    ptype = Grass;
    max_hp = 95;
    moves = [ confusion; leech_seed; solar_beam; psychic ];
    learnable_moves = [ (50, hyper_beam) ];
    evolution = None;
  }

(* Ninetales *)
let base_ninetales =
  {
    name = "Ninetales";
    ptype = Fire;
    max_hp = 73;
    moves = [ ember; quick_attack; fire_blast; confuse_ray ];
    learnable_moves = [ (45, flamethrower) ];
    evolution = None;
  }

(* Rapidash *)
let base_rapidash =
  {
    name = "Rapidash";
    ptype = Fire;
    max_hp = 65;
    moves = [ ember; quick_attack; fire_blast; stomp ];
    learnable_moves = [ (40, flamethrower) ];
    evolution = None;
  }

(* Magmar *)
let base_magmar =
  {
    name = "Magmar";
    ptype = Fire;
    max_hp = 65;
    moves = [ ember; leer; fire_punch; fire_blast ];
    learnable_moves = [ (43, flamethrower) ];
    evolution = None;
  }

(* Flareon *)
let base_flareon =
  {
    name = "Flareon";
    ptype = Fire;
    max_hp = 65;
    moves = [ ember; quick_attack; fire_blast; bite ];
    learnable_moves = [ (36, flamethrower) ];
    evolution = None;
  }

(* Vaporeon *)
let base_vaporeon =
  {
    name = "Vaporeon";
    ptype = Water;
    max_hp = 130;
    moves = [ water_gun; quick_attack; hydro_pump; aurora_beam ];
    learnable_moves = [ (42, water_pulse) ];
    evolution = None;
  }

(* Lapras *)
let base_lapras =
  {
    name = "Lapras";
    ptype = Water;
    max_hp = 130;
    moves = [ water_gun; growl; ice_beam; hydro_pump ];
    learnable_moves = [ (50, blizzard) ];
    evolution = None;
  }

(* Tentacruel *)
let base_tentacruel =
  {
    name = "Tentacruel";
    ptype = Water;
    max_hp = 80;
    moves = [ bubble; water_gun; wrap; hydro_pump ];
    learnable_moves = [ (50, blizzard) ];
    evolution = None;
  }

(* Aerodactyl *)
let base_aerodactyl =
  {
    name = "Aerodactyl";
    ptype = Flying;
    max_hp = 80;
    moves = [ wing_attack; bite; fly; hyper_beam ];
    learnable_moves = [ (60, dragon_claw) ];
    evolution = None;
  }

let starters_base = [ base_bulbasaur; base_charmander; base_squirtle ]

let wild_pokemon_base =
  [
    base_golduck;
    base_jigglypuff;
    base_psyduck;
    base_pikachu;
    base_pidgey;
    base_rattata;
    base_spearow;
  ]