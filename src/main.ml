(* File to start the UI  *)
open Printf

(* Menu options *)
let menu = [
  "Choose your starter pokemon";
  "Battle wild pokemon";
  "Exit";
]

(* Display main menu *)
let rec display_menu () =
  printf "\nMain Menu:\n";
  List.iteri (fun idx option -> printf "%d. %s\n" (idx + 1) option) menu;
  printf "> ";

  match read_line () with
  | "1" -> choose_starter ()
  | "3" -> exit 0
  | _ -> printf "Invalid choice. Please try again.\n"; display_menu ()

(* Choose starter pokemon *)
and choose_starter () =
  let starters = ["Bulbasaur"; "Charmander"; "Squirtle"] in
  printf "\nChoose your starter pokemon:\n";
  List.iteri (fun idx p -> printf "%d. %s\n" (idx + 1) p) starters;
  printf "> ";

  match read_line () with
  | "1" | "2" | "3" as choice ->
      let chosen = List.nth starters (int_of_string choice - 1) in
      printf "You chose %s!\n" chosen;
      display_menu ()
  | _ -> printf "Invalid choice. Please try again.\n"; choose_starter ()

(* Simulate a battle with a wild pokemon
and battle_wild_pokemon () =
  let wild_pokemon = { name="Pidgey"; level=5 } in
  printf "\nA wild %s appeared!\n" wild_pokemon.name;
  (* Here, you would actually implement battle mechanics *)
  printf "You battled %s!\n" wild_pokemon.name;
  display_menu ()
*)

let () = display_menu ()