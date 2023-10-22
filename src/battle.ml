open Player
open Printf
open Pokemon
open Ai

type battle_state = { player : player; ai : player; winner : player option }

(** Initiate a battle between two pokemon player_pokemon and opponent. The battle_loop ends when either pokemon feints.*)
let rec battle_loop player_pokemon opponent =
  if player_pokemon.hp <= 0 then
    printf "Your %s fainted. You lost the battle!\n" player_pokemon.name
  else if opponent.hp <= 0 then
    printf "You defeated the wild %s! You won the battle!\n"
      (Pokemon.name opponent)
  else (
    printf "\nYour %s's HP: %d\n" player_pokemon.name player_pokemon.hp;
    printf "Wild %s's HP: %d\n" (Pokemon.name opponent) opponent.hp;

    (* Player's turn *)
    printf "Choose a move for %s:\n" player_pokemon.name;
    List.iteri
      (fun i (move : move) ->
        printf "%d. %s (Type: %s, Damage: %d)\n" (i + 1) move.name
          (ptype_to_string move.ptype)
          move.damage)
      player_pokemon.moves;

    let rec get_move_choice () =
      try
        let choice = read_int () in
        if choice >= 1 && choice <= List.length player_pokemon.moves then (
          let chosen_move = List.nth player_pokemon.moves (choice - 1) in
          printf "You chose %s!\n" chosen_move.name;
          let updated_opponent = Pokemon.attack chosen_move opponent in
          if updated_opponent.hp <= 0 then
            printf "You defeated the wild %s! You won the battle!\n"
              (Pokemon.name opponent)
          else
            let ai_move = choose_move opponent in
            printf "Wild %s chose %s!\n" (Pokemon.name opponent) ai_move.name;
            let updated_player_pokemon =
              Pokemon.attack ai_move player_pokemon
            in
            if updated_player_pokemon.hp <= 0 then
              printf "Your %s fainted. You lost the battle!\n"
                player_pokemon.name
            else battle_loop updated_player_pokemon updated_opponent)
        else (
          printf "Invalid move choice. Please enter a valid number: ";
          get_move_choice ())
      with Failure _ ->
        printf "Invalid input. Please enter a valid number: ";
        get_move_choice ()
    in
    get_move_choice ())
