open Pokemon

let random_choice list =
  List.nth list (Random.int (List.length list))

let choose_move pokemon =
  let available_moves = pokemon.moves in
  match available_moves with
  | [] -> failwith "No available moves for this Pokemon."
  | _ ->
    let move = random_choice available_moves in
    move

let take_turn ai_pokemon player_pokemon =
  let move = choose_move ai_pokemon in
  let updated_player_pokemon = attack move player_pokemon in
  updated_player_pokemon