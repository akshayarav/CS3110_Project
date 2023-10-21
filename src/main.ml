(* File to start the UI  *)
open Printf
open Pokemon

(* Menu options *)
let menu = [
  "Choose your starter pokemon";
  "Battle wild pokemon";
  "Exit";
]

(* Mutable reference to store the player's Pokémon *)
let player_pokemon = ref None

(* Display main menu *)
let rec display_menu () =
  printf "\nMain Menu:\n";
  List.iteri (fun idx option -> printf "%d. %s\n" (idx + 1) option) menu;
  printf "> ";

  match read_line () with
  | "1" -> choose_starter ()
  | "2" -> (match !player_pokemon with
            | Some pokemon -> battle_wild_pokemon pokemon
            | None -> printf "You need to choose a starter Pokémon first!\n"; display_menu ())
  | "3" -> exit 0
  | _ -> printf "Invalid choice. Please try again.\n"; display_menu ()

(* Choose starter pokemon *)
and choose_starter () =
  let starters = [("Bulbasaur", Grass); ("Charmander", Fire); ("Squirtle", Water)] in
  printf "\nChoose your starter pokemon:\n";
  List.iteri (fun idx (p, _) -> printf "%d. %s\n" (idx + 1) p) starters;
  printf "> ";

  match read_line () with
  | "1" | "2" | "3" as choice ->
      let chosen, ptype = List.nth starters (int_of_string choice - 1) in
      let starter_pokemon = create chosen ptype 100 [] 5 in
      player_pokemon := Some starter_pokemon;
      printf "You chose %s!\n" chosen;
      display_menu ()
  | _ -> printf "Invalid choice. Please try again.\n"; choose_starter ()

(* Simulate a battle with a wild pokemon *)
and battle_wild_pokemon player_pokemon =
  let wild_pokemon = create "Pidgey" Normal 100 [] 1 in
  printf "\nA wild %s appeared!\n" wild_pokemon.name;
  printf "You send out %s!\n" player_pokemon.name;

  (* Here you would implement the battle logic *)
  printf "You battled %s!\n" wild_pokemon.name;

  display_menu ()

let () = display_menu ()