type ptype = Fire | Water | Grass | Electric | Flying | Normal
type move = { name : string; damage : int; ptype : ptype }

let string_to_ptype = function
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
}

let create name ptype hp moves level = { name; ptype; hp; moves; level }
let attack move pokemon = { pokemon with hp = pokemon.hp - move.damage }
let to_string pokemon = pokemon.name ^ ": " ^ string_to_ptype pokemon.ptype
let name pokemon = pokemon.name
