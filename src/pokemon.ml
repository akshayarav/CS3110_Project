type ptype = Fire | Water | Grass | Electric | Flying | Normal
type move = { name : string; damage : int; m_ptype : ptype }

type base_pokemon = {
  name : string;
  ptype : ptype;
  max_hp : int;
  moves : move list;
}

type pokemon = {
  base : base_pokemon;
  mutable hp : int;
  mutable level : int;
  mutable xp : int * int;
  mutable feint : bool;
}

let ptype_to_string = function
  | Normal -> "Normal Type"
  | Fire -> "Fire Type"
  | Water -> "Water Type"
  | Electric -> "Electric Type"
  | Grass -> "Grass Type"
  | Flying -> "Flying Type"

(** Creates a new pokemon *)
let create base level =
  { base; hp = base.max_hp; level; xp = (0, 10 * level); feint = false }

(** Creates a new pokemon with a random hp *)
let create_random base level =
  {
    base;
    hp = Random.int base.max_hp;
    level;
    xp = (0, 10 * level);
    feint = false;
  }

(** Creates a deep copy of a pokemon *)
let copy_pokemon p =
  { p with hp = p.hp; xp = (fst p.xp, snd p.xp); feint = p.feint }

(** Pokemon's hp is updated when attacked *)
let attack move pokemon =
  let new_hp = pokemon.hp - move.damage in
  if new_hp <= 0 then (
    pokemon.hp <- 0;
    pokemon.feint <- true)
  else pokemon.hp <- new_hp

(** Prints out pokemon and its stats *)
let to_string pokemon =
  let feint_status = if pokemon.feint then " - FEINTED" else "" in
  pokemon.base.name ^ ": " ^ ptype_to_string pokemon.base.ptype ^ feint_status

(** Prints out the pokemon's name *)
let name pokemon = pokemon.base.name

(*Checks if enough xp to level up and updates accordingly*)
let level_up pokemon =
  let diff = fst pokemon.xp - snd pokemon.xp in
  if diff >= 0 then
    { pokemon with xp = (diff, snd pokemon.xp + (20 * (pokemon.level + 1))) }
  else pokemon

(* Adds XP gained in victory *)
let add_xp pokemon xp_earned =
  let updated_pokemon =
    { pokemon with xp = (fst pokemon.xp + xp_earned, snd pokemon.xp) }
  in
  level_up updated_pokemon
