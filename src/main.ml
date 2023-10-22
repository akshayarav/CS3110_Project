(* File to start the UI  *)
open Printf
open Pokemon
open Pokedex
open Player

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
  | "2" -> (
      match player.first_pokemon with
      | Some pokemon -> battle_wild_pokemon pokemon
      | None ->
          printf "You need to choose a starter Pokémon first!\n";
          display_menu player)
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
and battle_wild_pokemon player_pokemon =
  let wild_pokemon =
    List.nth Pokedex.wild_pokemon
      (Random.int (List.length Pokedex.wild_pokemon))
  in
  printf "\nA wild %s appeared!\n" wild_pokemon.name;
  printf "You send out %s!\n" player_pokemon.name;

  (* Here you would implement the battle logic *)
  printf "You battled %s!\n" wild_pokemon.name;

  display_menu player

let () = display_menu player
