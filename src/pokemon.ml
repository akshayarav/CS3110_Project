type ptype = Fire | Water | Grass | Electric | Flying | Normal
type move = { name : string; damage : int; ptype : ptype }

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
  hp : int;
  moves : move list;
  level : int;
  xp: (int*int);
  faint: bool;
}
(** Type for a pokemon has several stats *)

(** Creates a new pokemon *)
let create name ptype hp moves level = { name; ptype; hp; moves; level; xp = (0, 10); faint = false }

(** Pokemon's hp is updated when attacked *)
let attack move pokemon = { pokemon with hp = pokemon.hp - move.damage }

(** Prints out pokemon and its stats *)
let to_string pokemon = pokemon.name ^ ": " ^ ptype_to_string pokemon.ptype

(** Prints out the pokemon's name *)
let name pokemon = pokemon.name

(*Checks if enough xp to level up and updates accordingly*)
let level_up pokemon =
  let diff = fst pokemon.xp - snd pokemon.xp in
    if diff >= 0 then { pokemon with xp = (diff, snd pokemon.xp + 20)}
    else pokemon

(* Adds XP gained in victory *)
let add_xp pokemon xp_earned = 
  let updated_pokemon = 
    { pokemon with xp = (fst pokemon.xp + xp_earned, snd pokemon.xp)} in
  level_up updated_pokemon