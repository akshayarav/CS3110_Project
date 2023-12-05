open Printf
open Pokemon
open Trainer
open Player

(** Allows the player to select a non-fainted Pokémon from their team. Returns
    a tuple of the chosen Pokémon and an updated player record with
    current_pokemon set to this Pokémon. *)
let choose_new_pokemon player =
  printf "Choose a new Pokemon:\n";
  List.iteri
    (fun i pokemon ->
      if not pokemon.feint then
        printf "%d. %s (HP: %d)\n" (i + 1) pokemon.base.name pokemon.hp)
    player.team;

  let rec get_pokemon_choice () =
    try
      let choice = read_int () in
      if choice >= 1 && choice <= List.length player.team then
        let chosen_pokemon = List.nth player.team (choice - 1) in
        if not chosen_pokemon.feint then
          Some chosen_pokemon
        else (
          printf "This Pokemon has fainted. Choose another one.\n";
          get_pokemon_choice ())
      else (
        printf "Invalid choice. Please enter a valid number: ";
        get_pokemon_choice ())
    with
    | Failure _ ->
        printf "Invalid input. Please enter a valid number: ";
        get_pokemon_choice ()
    | _ ->
        printf "An unexpected error occurred. Exiting the choice.\n";
        raise Exit
  in
  match get_pokemon_choice () with
  | Some chosen_pokemon -> (chosen_pokemon, { player with current_pokemon = Some chosen_pokemon })
  | None -> failwith "No Pokemon was chosen"

(** Initiate a battle between two pokemon player_pokemon and opponent.
  The battle_loop ends when either pokemon feints.
  If player_pokemon wins battle_loop returns true else false *)
let rec wild_battle_loop player_pokemon opponent player =
  if player_pokemon.hp <= 0 then (
    printf "Your %s fainted.\n" player_pokemon.base.name;
    player_pokemon.feint <- true;

    let available_pokemon = List.filter (fun p -> not p.feint) player.team in
    if List.length available_pokemon = 0 then (
      printf "All your Pokemon have fainted. You lost the battle!\n";
      false (* Player lost *))
    else (
      let new_pokemon, updated_player = choose_new_pokemon player in
      printf "Go %s!\n" new_pokemon.base.name;
      wild_battle_loop new_pokemon opponent updated_player))
  else if opponent.hp <= 0 then (
    printf "You defeated the wild %s! You won the battle! \n" (Pokemon.name opponent);
    true (* Player won *))
  else (
    printf "\nYour %s's HP: %d\n" player_pokemon.base.name player_pokemon.hp;
    printf "Wild %s's HP: %d\n" (Pokemon.name opponent) opponent.hp;

    (* Player's turn *)
    printf "Choose an action for %s:\n" player_pokemon.base.name;
    List.iteri
      (fun i (move : move) ->
        printf "%d. %s (Type: %s, Damage: %d)\n" (i + 1) move.name
          (ptype_to_string move.m_ptype)
          move.damage)
      player_pokemon.base.moves;
    printf "%d. Switch Pokemon\n" (List.length player_pokemon.base.moves + 1);

    let rec get_player_choice () =
      try
        let choice = read_int () in
        if choice >= 1 && choice <= List.length player_pokemon.base.moves then (
          let chosen_move = List.nth player_pokemon.base.moves (choice - 1) in
          printf "You chose %s!\n" chosen_move.name;
          Pokemon.attack chosen_move opponent player_pokemon;  (* Apply player's chosen move *)
          false  (* Do not end the battle yet, proceed to AI's turn *)
        )
        else if choice = List.length player_pokemon.base.moves + 1 then (
          let new_pokemon, updated_player = choose_new_pokemon player in
          printf "Go %s!\n" new_pokemon.base.name;
          wild_battle_loop new_pokemon opponent updated_player  (* New Pokémon, start a new battle loop iteration *)
        )
        else (
          printf "Invalid choice. Please enter a valid number: ";
          get_player_choice ()
        )
      with
      | Failure _ ->
          printf "Invalid input. Please enter a valid number: ";
          get_player_choice ()
      | _ ->
          printf "An unexpected error occurred. Exiting the battle.\n";
          false
    in

    if get_player_choice () then
      true  (* Battle ended, player won *)
    else if opponent.hp <= 0 then
      true  (* Opponent's Pokémon fainted, player won *)
    else (
      (* AI's turn *)
      let ai_move = Ai.choose_move opponent in
      printf "Wild %s chose %s!\n" (Pokemon.name opponent) ai_move.name;
      Pokemon.attack ai_move player_pokemon opponent;

      if player_pokemon.hp <= 0 then (
        (* Handle player's Pokémon fainting after AI's turn *)
        let available_pokemon = List.filter (fun p -> not p.feint) player.team in
        if List.length available_pokemon = 0 then (
          printf "All your Pokemon have fainted. You lost the battle!\n";
          false (* Player lost *)
        )
        else (
          let new_pokemon, updated_player = choose_new_pokemon player in
          printf "Go %s!\n" new_pokemon.base.name;
          wild_battle_loop new_pokemon opponent updated_player
        )
      )
      else
        (* Continue the battle if the player's Pokémon didn't faint *)
        wild_battle_loop player_pokemon opponent player
    )
  )

let update_trainer_team (trainer: trainer) (new_team: pokemon list) =
  { trainer with team = new_team }

let rec trainer_battle_loop player_pokemon opponent player trainer =
  if player_pokemon.hp <= 0 then (
    printf "Your %s fainted.\n" player_pokemon.base.name;
    player_pokemon.feint <- true;
    let available_pokemon = List.filter (fun p -> not p.feint) player.team in
    if List.length available_pokemon = 0 then (
      printf "All your Pokemon have fainted. You lost the battle!\n";
      false
    ) else (
      let new_pokemon, updated_player = choose_new_pokemon player in
      printf "Go %s!\n" new_pokemon.base.name;
      trainer_battle_loop new_pokemon opponent updated_player trainer
    )
  ) else if opponent.hp <= 0 then (
    printf "You defeated Trainer %s's %s!\n" trainer.name (Pokemon.name opponent);
    let remaining_opponents = List.filter (fun p -> not p.feint) trainer.team in
    match remaining_opponents with
    | [] ->
        printf "You have defeated all of Trainer %s's Pokemon!\n" trainer.name;
        true (* End the loop, indicating the player has won *)
    | new_opponent :: rest ->
        let updated_trainer = update_trainer_team trainer rest in
        printf "Trainer %s sends out %s!\n" trainer.name new_opponent.base.name;
        trainer_battle_loop player_pokemon new_opponent player updated_trainer
  ) else (
    printf "\nYour %s's HP: %d\n" player_pokemon.base.name player_pokemon.hp;
    printf "Trainer %s's %s's HP: %d\n" trainer.name (Pokemon.name opponent) opponent.hp;
    printf "Choose an action for %s:\n" player_pokemon.base.name;
    let moves = player_pokemon.base.moves in
    for i = 0 to List.length moves - 1 do
      let move = List.nth moves i in
      printf "%d. %s (Type: %s, Damage: %d)\n" (i + 1) move.name
        (ptype_to_string move.m_ptype)
        move.damage
    done;
    printf "%d. Switch Pokemon\n" (List.length player_pokemon.base.moves + 1);

    let rec get_player_choice () =
      try
        let choice = read_int () in
        if choice >= 1 && choice <= List.length player_pokemon.base.moves then (
          let chosen_move = List.nth player_pokemon.base.moves (choice - 1) in
          printf "You chose %s!\n" chosen_move.name;
          Pokemon.attack chosen_move opponent player_pokemon;
          false
        )
        else if choice = List.length player_pokemon.base.moves + 1 then (
          let new_pokemon, updated_player = choose_new_pokemon player in
          printf "Go %s!\n" new_pokemon.base.name;
          trainer_battle_loop new_pokemon opponent updated_player trainer
        )
        else (
          printf "Invalid choice. Please enter a valid number: ";
          get_player_choice ()
        )
      with
      | Failure _ ->
          printf "Invalid input. Please enter a valid number: ";
          get_player_choice ()
      | _ ->
          printf "An unexpected error occurred. Exiting the battle.\n";
          false
    in

    if get_player_choice () then
      true
    else (
      let ai_move = Ai.choose_move opponent in
      printf "Trainer %s's %s chose %s!\n" trainer.name (Pokemon.name opponent) ai_move.name;
      Pokemon.attack ai_move player_pokemon opponent;
      if player_pokemon.hp <= 0 then (
        let available_pokemon = List.filter (fun p -> not p.feint) player.team in
        if List.length available_pokemon = 0 then (
          printf "All your Pokemon have fainted. You lost the battle!\n";
          false
        ) else (
          let new_pokemon, updated_player = choose_new_pokemon player in
          printf "Go %s!\n" new_pokemon.base.name;
          trainer_battle_loop new_pokemon opponent updated_player trainer
        )
      ) else
        trainer_battle_loop player_pokemon opponent player trainer
    )
  )