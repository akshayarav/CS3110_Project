(* File to start the UI  *)
open Printf
open Pokedex
open Player

(* open Ai *)

(* Menu options *)
let menu =
  [
    "Choose your starter pokemon";
    "Battle wild pokemon";
    "View player stats";
    "Exit";
  ]

(* Stores the player *)
let player = ref Player.new_player

(* Display main menu *)
let rec display_menu () =
  printf "\nMain Menu:\n";
  List.iteri (fun idx option -> printf "%d. %s\n" (idx + 1) option) menu;
  printf "> ";

  match read_line () with
  | "1" -> choose_starter ()
  | "2" -> wild_battle ()
  | "3" ->
      printf "%s\n" (Player.player_to_string !player);
      display_menu ()
  | "4" -> exit 0
  | _ ->
      printf "Invalid choice. Please try again.\n";
      display_menu ()

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
      player := Player.add_team starter_pokemon !player;
      (* Update the mutable reference *)
      print_endline ("You chose " ^ Pokemon.name starter_pokemon);
      display_menu () (* Pass the updated player *)
  | _ ->
      printf "Invalid choice. Please try again.\n";
      choose_starter ()

(* Simulate a battle with a wild pokemon *)
and wild_battle () =
  let opponent_index = Random.int (List.length wild_pokemon) in
  let opponent = List.nth wild_pokemon opponent_index in
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  printf "A wild %s appears!\n" (Pokemon.name opponent);

  let won = Battle.battle_loop player_pokemon opponent in
  if won then (
    printf "Do you want to add the wild %s to your team? (yes/no): "
      (Pokemon.name opponent);
    match String.lowercase_ascii (read_line ()) with
    | "yes" ->
        player := Player.add_team opponent !player;
        printf "Added %s to your team.\n" (Pokemon.name opponent)
    | "no" ->
        printf "You chose not to add %s to your team.\n" (Pokemon.name opponent)
    | _ ->
        printf "Invalid choice. Not adding %s to your team.\n"
          (Pokemon.name opponent));
  display_menu ()

let () = display_menu ()
