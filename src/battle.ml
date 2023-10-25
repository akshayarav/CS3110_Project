open Player
open Printf
open Pokemon

type battle_state = { player : player; ai : player; winner : player option }

(** Initiate a battle between two pokemon player_pokemon and opponent. 
    The battle_loop ends when either pokemon feints. 
    If player_pokemon wins battle_loop returns true else false *)
let rec battle_loop player_pokemon opponent =
  if player_pokemon.hp <= 0 then (
    printf "Your %s feinted. You lost the battle!\n" player_pokemon.base.name;
    player_pokemon.feint <- true;
    false (* Player lost *))
  else if opponent.hp <= 0 then (
    printf "You defeated the wild %s! You won the battle!\n"
      (Pokemon.name opponent);
    true (* Player won *))
  else (
    printf "\nYour %s's HP: %d\n" player_pokemon.base.name player_pokemon.hp;
    printf "Wild %s's HP: %d\n" (Pokemon.name opponent) opponent.hp;

    (* Player's turn *)
    printf "Choose a move for %s:\n" player_pokemon.base.name;
    List.iteri
      (fun i (move : move) ->
        printf "%d. %s (Type: %s, Damage: %d)\n" (i + 1) move.name
          (ptype_to_string move.m_ptype)
          move.damage)
      player_pokemon.base.moves;

    let rec get_move_choice () =
      try
        let choice = read_int () in
        if choice >= 1 && choice <= List.length player_pokemon.base.moves then (
          let chosen_move = List.nth player_pokemon.base.moves (choice - 1) in
          printf "You chose %s!\n" chosen_move.name;
          Pokemon.attack chosen_move opponent;

          if opponent.feint then (
            printf "You defeated the wild %s! You won the battle!\n"
              (Pokemon.name opponent);
            true (* Player won *))
          else
            let ai_move = Ai.choose_move opponent in
            printf "Wild %s chose %s!\n" (Pokemon.name opponent) ai_move.name;
            Pokemon.attack ai_move player_pokemon;

            if player_pokemon.hp <= 0 then (
              printf "Your %s feinted. You lost the battle!\n"
                player_pokemon.base.name;
              player_pokemon.feint <- true;
              false (* Player lost *))
            else battle_loop player_pokemon opponent)
        else (
          printf "Invalid move choice. Please enter a valid number: ";
          get_move_choice ())
      with
      | Failure _ ->
          printf "Invalid input. Please enter a valid number: ";
          get_move_choice ()
      | _ ->
          printf "An unexpected error occurred. Exiting the battle.\n";
          false (* Assuming a loss in case of unexpected errors *)
    in
    get_move_choice ())
