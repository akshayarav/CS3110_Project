open Pokemon
open Yojson.Basic.Util

(* Function to convert a JSON object to a move *)
let json_to_move json =
  {
    name = json |> member "name" |> to_string;
    damage = json |> member "damage" |> to_int;
    m_ptype = json |> member "m_ptype" |> to_string |> Pokemon.string_to_ptype;
  }

(* Function to read and parse the JSON file for moves *)
let moves_from_json file =
  Yojson.Basic.from_file file |> to_list |> List.map json_to_move

(* Load all moves from JSON *)
let all_moves = moves_from_json "src/data/moves.json"

let rec find_move_by_name name (moves : move list) =
  match moves with
  | [] -> failwith ("Move not found: " ^ name)
  | move :: rest ->
      if move.Pokemon.name = name then move else find_move_by_name name rest

let string_to_move move_name : Pokemon.move =
  find_move_by_name move_name all_moves
