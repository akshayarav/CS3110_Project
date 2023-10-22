(* File to start the UI  *)
open Printf
open Pokedex
open Player

(* open Ai *)

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
  let player_pokemon =
    match player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  printf "A wild %s appears!\n" (Pokemon.name opponent);

  Battle.battle_loop player_pokemon opponent;
  display_menu player

let () = display_menu player
