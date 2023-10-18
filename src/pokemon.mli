(** Type representing the various Pokemon types. *)
type ptype = 
  | Fire
  | Water
  | Grass
  | Electric
  (* Add other types as needed *)

(** Type representing a move a Pokemon can perform. *)
type move = {
  name: string;
  damage: int;
  ptype: ptype;
}

(** A pokemon representation. *)
module type Pokemon = sig
  type t = {
    name : string;
    ptype : string;
    hp : int;
    moves : move list;
  }
  (** Stats of the Pokemon *)

  val create : string -> string -> int -> move list -> t
  (** Create a pokemon *)
end