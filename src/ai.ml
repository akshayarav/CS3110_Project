open Pokemon

let random_choice list = List.nth list (Random.int (List.length list))

let choose_move pokemon =
  let available_moves = pokemon.base.moves in
  match available_moves with
  | [] -> failwith "No available moves for this Pokemon."
  | _ ->
      let move = random_choice available_moves in
      move
