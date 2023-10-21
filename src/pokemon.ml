type ptype =
| Fire
| Water
| Grass
| Electric
| Flying
| Normal

type move = {
  name: string;
  damage: int;
  ptype: ptype;
}

type t = {
  name : string;
  ptype : ptype;
  hp : int;
  moves : string list;
  level : int;
}

let create name ptype hp moves level= {
  name = name;
  ptype = ptype;
  hp = hp;
  moves = moves;
  level = level
}

let attack move pokemon = { pokemon with hp = pokemon.hp - move.damage }