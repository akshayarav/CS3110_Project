(** Type representing the various Pokemon types. *)
type ptype

(** Type representing a move a Pokemon can perform. *)
type move 

(** A pokemon representation. *)
type t = {
  name : string;
  ptype : string;
  hp : int;
  moves : move list;
}
(** Stats of the Pokemon *)

val create : string -> string -> int -> move list -> t
(** Create a pokemon *)

val attack : move -> t -> t
(** A move is applied onto a Pokemon and the Pokemon's hp is updated*)