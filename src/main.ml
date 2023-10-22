(* File to start the UI  *)
open Printf
open Pokemon
open Pokedex
open Player
open Ai
(* open Battle *)

(* Menu options *)
let menu = [ "Choose your starter pokemon"; "Battle wild pokemon"; "Exit" ]

(* Mutable reference to store the player's Pokémon *)
let player = Player.new_player

(* Display main menu *)
let rec display_menu player =
  printf "\nMain Menu:\n";
  List.iteri (fun idx option -> printf "%d. %s\n" (idx + 1) option) menu;
  printf "> ";

  match read_line () with
  | "1" -> choose_starter ()
  | "2" -> wild_battle player
  | "3" -> exit 0
  | _ ->
      printf "Invalid choice. Please try again.\n";
      display_menu player

(* Choose starter pokemon *)
and choose_starter () =
  printf "\nChoose your starter pokemon:\n";
  List.iteri
    (fun index pokemon ->
      print_endline
        (string_of_int (index + 1) ^ ". " ^ Pokemon.to_string pokemon))
    starters;
  printf "> ";

  match read_line () with
  | ("1" | "2" | "3") as choice ->
      let starter_pokemon = List.nth starters (int_of_string choice - 1) in
      let updated_player = Player.add_team starter_pokemon player in
      print_endline ("You chose " ^ Pokemon.name starter_pokemon);
      display_menu updated_player
  | _ ->
      printf "Invalid choice. Please try again.\n";
      choose_starter ()

(* Simulate a battle with a wild pokemon *)
and wild_battle player =
  let opponent_index = Random.int (List.length wild_pokemon) in
  let opponent = List.nth wild_pokemon opponent_index in
  let player_pokemon = match player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  printf "A wild %s appears!\n" (Pokemon.name opponent);
  
  let rec battle_loop player_pokemon opponent =
    if player_pokemon.hp <= 0 then (
      printf "Your %s fainted. You lost the battle!\n" player_pokemon.name;
      display_menu player
    )
    else if opponent.hp <= 0 then (
      printf "You defeated the wild %s! You won the battle!\n" (Pokemon.name opponent);
      display_menu player
    )
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
          if choice >= 1 && choice <= List.length player_pokemon.moves then
            let chosen_move = List.nth player_pokemon.moves (choice - 1) in
            printf "You chose %s!\n" chosen_move.name;
            let updated_opponent = Pokemon.attack chosen_move opponent in
            if updated_opponent.hp <= 0 then (
              printf "You defeated the wild %s! You won the battle!\n" (Pokemon.name opponent);
              display_menu player
            )
            else (
              let ai_move = choose_move opponent in
              printf "Wild %s chose %s!\n" (Pokemon.name opponent) ai_move.name;
              let updated_player_pokemon = Pokemon.attack ai_move player_pokemon in
              if updated_player_pokemon.hp <= 0 then (
                printf "Your %s fainted. You lost the battle!\n" player_pokemon.name;
                display_menu player
              )
              else (
                battle_loop updated_player_pokemon updated_opponent
              )
            )
          else (
            printf "Invalid move choice. Please enter a valid number: ";
            get_move_choice ()
          )
        with
        | Failure _ ->
            printf "Invalid input. Please enter a valid number: ";
            get_move_choice ()
      in
      get_move_choice ()
    )
  in
  battle_loop player_pokemon opponent


let () = display_menu player
