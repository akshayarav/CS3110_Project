(* Class Pokemon takes in a type of a pokemon and provides functions  *)

module Pokemon = struct
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
end