open Player
(* open Printf *)
open Pokemon

type battle_state = { player : player; ai : player; winner : player option }



(* Function to battle a wild pokemon *)

let choose_move player n = List.nth player.moves n
(* let battle_wild_pokemon player = prompt_move player *)
