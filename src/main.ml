(* File to start the UI  *)
open Printf
open Pokemon
open Pokedex
open Player
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
(* Simulate a battle with a wild pokemon *)
and wild_battle player =
  match player.current_pokemon with
  | Some pokemon ->
      let moves = pokemon.moves in
      printf "Choose a move for %s:\n" (Pokemon.name pokemon);
      List.iteri
        (fun i (move : move) ->
          printf "%d. %s (Type: %s, Damage: %d)\n" (i + 1) move.name
            (ptype_to_string move.ptype)
            move.damage)
        moves;
      let rec get_move_choice () =
        try
          let choice = read_int () in
          if choice >= 1 && choice <= List.length moves then
            let chosen_move = List.nth moves (choice - 1) in
            printf "You chose %s!\n" chosen_move.name
          else (
            printf "Invalid move choice. Please enter a valid number: ";
            get_move_choice ())
        with Failure _ ->
          printf "Invalid input. Please enter a valid number: ";
          get_move_choice ()
      in
      get_move_choice ();
      display_menu player
  | None ->
      printf "No current Pokémon to choose a move for\n";
      display_menu player
let () = display_menu player
