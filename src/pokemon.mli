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

val create : string -> ptype -> int -> string list -> int -> t
val attack : move -> t -> t