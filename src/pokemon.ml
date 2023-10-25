type ptype = Fire | Water | Grass | Electric | Flying | Normal
type move = { name : string; damage : int; m_ptype : ptype }

let ptype_to_string = function
  | Normal -> "Normal Type"
  | Fire -> "Fire Type"
  | Water -> "Water Type"
  | Electric -> "Electric Type"
  | Grass -> "Grass Type"
  | _ -> failwith "Unknown Type"

type pokemon = {
  name : string;
  ptype : ptype;
  mutable max_hp : int;
  mutable hp : int;
  moves : move list;
  level : int;
  xp : int * int;
  mutable feint : bool;
}
(** Type for a pokemon has several stats *)

(** Creates a new pokemon *)
let create name ptype hp moves level =
  { name; ptype; max_hp = hp; hp; moves; level; xp = (0, 10); feint = false }

(** Creates a deep copy of a pokemon *)
let copy_pokemon (p : pokemon) : pokemon =
  { p with hp = p.hp; feint = p.feint; xp = (0, 10) }

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
  pokemon.name ^ ": " ^ ptype_to_string pokemon.ptype ^ feint_status

(** Prints out the pokemon's name *)
let name pokemon = pokemon.name

(*Checks if enough xp to level up and updates accordingly*)
let level_up pokemon =
  let diff = fst pokemon.xp - snd pokemon.xp in
  if diff >= 0 then { pokemon with xp = (diff, snd pokemon.xp + 20) }
  else pokemon

(* Adds XP gained in victory *)
let add_xp pokemon xp_earned =
  let updated_pokemon =
    { pokemon with xp = (fst pokemon.xp + xp_earned, snd pokemon.xp) }
  in
  level_up updated_pokemon
