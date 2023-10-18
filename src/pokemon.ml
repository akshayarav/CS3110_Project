type ptype =     
| Fire
| Water
| Grass
| Electric

type move = {
  name: string;
  damage: int;
  ptype: ptype;
}

type t = {
  name : string;
  ptype : string;
  hp : int;
  moves : string list;
}

let create name ptype hp moves = {
  name = name;
  ptype = ptype;
  hp = hp;
  moves = moves;
}

let attack move pokemon = { pokemon with hp = pokemon.hp - move.damage }