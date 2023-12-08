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

let type_effectiveness : (ptype, ptype list) Hashtbl.t = Hashtbl.create 18

let () =
  Hashtbl.add type_effectiveness Normal [];
  Hashtbl.add type_effectiveness Fire [Grass; Ice; Bug; Steel];
  Hashtbl.add type_effectiveness Water [Fire; Ground; Rock];
  Hashtbl.add type_effectiveness Electric [Water; Flying];
  Hashtbl.add type_effectiveness Grass [Water; Ground; Rock];
  Hashtbl.add type_effectiveness Ice [Grass; Ground; Flying; Dragon];
  Hashtbl.add type_effectiveness Fighting [Normal; Ice; Rock; Dark; Steel];
  Hashtbl.add type_effectiveness Poison [Grass; Fairy];
  Hashtbl.add type_effectiveness Ground [Fire; Electric; Poison; Rock; Steel];
  Hashtbl.add type_effectiveness Flying [Grass; Fighting; Bug];
  Hashtbl.add type_effectiveness Psychic [Fighting; Poison];
  Hashtbl.add type_effectiveness Bug [Grass; Psychic; Dark];
  Hashtbl.add type_effectiveness Rock [Fire; Ice; Flying; Bug];
  Hashtbl.add type_effectiveness Ghost [Psychic; Ghost];
  Hashtbl.add type_effectiveness Dragon [Dragon];
  Hashtbl.add type_effectiveness Dark [Psychic; Ghost];
  Hashtbl.add type_effectiveness Steel [Ice; Rock; Fairy];
  Hashtbl.add type_effectiveness Fairy [Fighting; Dragon; Dark]

let type_ineffectiveness : (ptype, ptype list) Hashtbl.t = Hashtbl.create 18

let () =
  Hashtbl.add type_ineffectiveness Normal [Rock; Steel];
  Hashtbl.add type_ineffectiveness Fire [Fire; Water; Rock; Dragon];
  Hashtbl.add type_ineffectiveness Water [Water; Grass; Dragon];
  Hashtbl.add type_ineffectiveness Electric [Electric; Grass; Dragon];
  Hashtbl.add type_ineffectiveness Grass [Fire; Grass; Poison; Flying; Bug; Dragon; Steel];
  Hashtbl.add type_ineffectiveness Ice [Fire; Water; Ice; Steel];
  Hashtbl.add type_ineffectiveness Fighting [Poison; Flying; Psychic; Bug; Fairy];
  Hashtbl.add type_ineffectiveness Poison [Poison; Ground; Rock; Ghost];
  Hashtbl.add type_ineffectiveness Ground [Grass; Bug];
  Hashtbl.add type_ineffectiveness Flying [Electric; Rock; Steel];
  Hashtbl.add type_ineffectiveness Psychic [Psychic; Steel];
  Hashtbl.add type_ineffectiveness Bug [Fire; Fighting; Flying; Poison; Ghost; Steel; Fairy];
  Hashtbl.add type_ineffectiveness Rock [Fighting; Ground; Steel];
  Hashtbl.add type_ineffectiveness Ghost [Dark];
  Hashtbl.add type_ineffectiveness Dragon [Steel];
  Hashtbl.add type_ineffectiveness Dark [Fighting; Dark; Fairy];
  Hashtbl.add type_ineffectiveness Steel [Fire; Water; Electric; Steel];
  Hashtbl.add type_ineffectiveness Fairy [Fire; Poison; Steel]

let type_noneffective : (ptype, ptype list) Hashtbl.t = Hashtbl.create 18
let () =
  Hashtbl.add type_noneffective Normal [Ghost];
  Hashtbl.add type_noneffective Fire [];
  Hashtbl.add type_noneffective Water [];
  Hashtbl.add type_noneffective Electric [Ground];
  Hashtbl.add type_noneffective Grass [];
  Hashtbl.add type_noneffective Ice [Ice];
  Hashtbl.add type_noneffective Fighting [Ghost];
  Hashtbl.add type_noneffective Poison [Steel];
  Hashtbl.add type_noneffective Ground [Flying];
  Hashtbl.add type_noneffective Flying [];
  Hashtbl.add type_noneffective Psychic [Dark];
  Hashtbl.add type_noneffective Bug [];
  Hashtbl.add type_noneffective Rock [];
  Hashtbl.add type_noneffective Ghost [Normal];
  Hashtbl.add type_noneffective Dragon [Steel];
  Hashtbl.add type_noneffective Dark [];
  Hashtbl.add type_noneffective Steel [];
  Hashtbl.add type_noneffective Fairy []

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
  mutable current_max_hp : int;
  mutable level : int;
  mutable xp : int * int;
  mutable feint : bool;
  mutable damage_modifier : float;
}

let get_type (p:pokemon) = p.base.ptype

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
    current_max_hp = base.max_hp; (* Initialize current max HP *)
    level;
    xp = (0, 10 * level);
    feint = false;
    damage_modifier = 1.;
  }

(** Creates a new pokemon with a random hp, ensuring it's at least half of the max HP *)
let create_random base level =
  let min_hp = base.max_hp / 2 in  (* Minimum HP is half of the max HP *)
  let random_hp = min_hp + Random.int (base.max_hp - min_hp + 1) in
  {
    base;
    hp = random_hp;
    current_max_hp = base.max_hp; (* Initialize current max HP *)
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
  let effectiveness =
    match Hashtbl.find_opt type_effectiveness move.m_ptype with
    | Some(eff) ->
        if List.mem (get_type opponent_pokemon) eff then 2.0
        else
          (match Hashtbl.find_opt type_ineffectiveness move.m_ptype with
          | Some ineff ->
              if List.mem (get_type opponent_pokemon) ineff then 0.5
              else 1.0
          | None -> 1.0)
    | None -> 1.0
  in
  let damage_multiplier = effectiveness *. player_pokemon.damage_modifier in
  let new_hp =
    opponent_pokemon.hp - int_of_float (float_of_int move.damage *. damage_multiplier)
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
      let new_max_hp = pokemon.current_max_hp + (new_level * 2) in  (* Updated to use current_max_hp *)
      let damage_increase = 0.1 in

      let updated_pokemon =
        {
          pokemon with
          level = new_level;
          current_max_hp = new_max_hp; (* Update current max HP *)
          hp = if pokemon.hp > 0 then new_max_hp else pokemon.hp; (* Heal if not feinted *)
          damage_modifier = pokemon.damage_modifier +. damage_increase;
          xp = (current_xp - next_level_xp, next_level_xp + (20 * new_level));
        }
      in
      level_up_helper updated_pokemon
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
