type ptype =
  | Normal
  | Fire
  | Water
  | Electric
  | Grass
  | Ice
  | Fighting
  | Poison
  | Ground
  | Flying
  | Psychic
  | Bug
  | Rock
  | Ghost
  | Dragon
  | Dark
  | Steel
  | Fairy

type move = { name : string; damage : int; m_ptype : ptype }

type base_pokemon = {
  name : string;
  ptype : ptype;
  max_hp : int;
  moves : move list;
  learnable_moves : (int * move) list;
  evolution : (int * base_pokemon) option;
}

type pokemon = {
  base : base_pokemon;
  mutable hp : int;
  mutable level : int;
  mutable xp : int * int;
  mutable feint : bool;
  mutable damage_modifier : float;
}

let ptype_to_string = function
  | Normal -> "Normal Type"
  | Fire -> "Fire Type"
  | Water -> "Water Type"
  | Electric -> "Electric Type"
  | Grass -> "Grass Type"
  | Ice -> "Ice Type"
  | Fighting -> "Fighting Type"
  | Poison -> "Poison Type"
  | Ground -> "Ground Type"
  | Flying -> "Flying Type"
  | Psychic -> "Psychic Type"
  | Bug -> "Bug Type"
  | Rock -> "Rock Type"
  | Ghost -> "Ghost Type"
  | Dragon -> "Dragon Type"
  | Dark -> "Dark Type"
  | Steel -> "Steel Type"
  | Fairy -> "Fairy Type"

(** Creates a new pokemon *)
let create base level =
  {
    base;
    hp = base.max_hp;
    level;
    xp = (0, 10 * level);
    feint = false;
    damage_modifier = 1.;
  }

(** Creates a new pokemon with a random hp *)
let create_random base level =
  {
    base;
    hp = Random.int base.max_hp;
    level;
    xp = (0, 10 * level);
    feint = false;
    damage_modifier = 1.;
  }

(** Creates a deep copy of a pokemon *)
let copy_pokemon p =
  { p with hp = p.hp; xp = (fst p.xp, snd p.xp); feint = p.feint }

(** Pokemon's hp is updated when attacked *)
let attack move opponent_pokemon player_pokemon =
  let new_hp =
    opponent_pokemon.hp
    - int_of_float (player_pokemon.damage_modifier *. float_of_int move.damage)
  in
  if new_hp <= 0 then (
    opponent_pokemon.hp <- 0;
    opponent_pokemon.feint <- true)
  else opponent_pokemon.hp <- new_hp

(** Prints out pokemon and its stats *)
let to_string pokemon =
  let feint_status = if pokemon.feint then " - FEINTED" else "" in
  let level_info =
    "Level: "
    ^ string_of_int pokemon.level
    ^ ", XP: "
    ^ string_of_int (fst pokemon.xp)
    ^ "/"
    ^ string_of_int (snd pokemon.xp)
  in
  pokemon.base.name ^ ": "
  ^ ptype_to_string pokemon.base.ptype
  ^ ", " ^ level_info ^ feint_status

(** Prints out the pokemon's name *)
let name pokemon = pokemon.base.name

let max_level = 100 (* Set the maximum level cap *)

let level_up pokemon =
  let rec level_up_helper pokemon =
    let current_xp, next_level_xp = pokemon.xp in
    if current_xp >= next_level_xp && pokemon.level < max_level then
      let new_level = pokemon.level + 1 in
      let new_max_hp = pokemon.base.max_hp + (new_level * 2) in
      (* Example stat increase *)
      let damage_increase = 0.1 in

      (* Modify as needed *)
      let updated_pokemon =
        {
          pokemon with
          level = new_level;
          hp = new_max_hp;
          damage_modifier = pokemon.damage_modifier +. damage_increase;
          xp = (current_xp - next_level_xp, next_level_xp + (20 * new_level));
        }
      in
      level_up_helper
        updated_pokemon (* Recursive call for multiple level-ups *)
    else pokemon
  in
  level_up_helper pokemon

(* Adds XP gained in victory *)
let add_xp pokemon xp_earned =
  let updated_pokemon =
    { pokemon with xp = (fst pokemon.xp + xp_earned, snd pokemon.xp) }
  in
  level_up updated_pokemon

(* Calculate experience gained from defeating an opponent *)
let calculate_xp_gained opponent_level = 10 * opponent_level

(*Checks for new moves for the pokemon*)
let check_new_moves pokemon =
  List.filter (fun (lvl, _) -> lvl = pokemon.level) pokemon.base.learnable_moves

(*Checks if the pokemon can evolve*)
let check_evolution pokemon =
  match pokemon.base.evolution with
  | Some (lvl, evolved_form) when pokemon.level >= lvl -> Some evolved_form
  | _ -> None

let evolve_pokemon pokemon evolved_form =
  { pokemon with base = evolved_form; hp = evolved_form.max_hp }

(* Function to add or replace a move *)
let learn_move pokemon new_move move_to_replace =
  let new_moves =
    List.mapi
      (fun i move -> if i = move_to_replace then new_move else move)
      pokemon.base.moves
  in
  { pokemon with base = { pokemon.base with moves = new_moves } }
