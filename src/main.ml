(* File to start the UI  *)
open Printf
open Pokedex
open Player

(* open Ai *)

(* Stores the player *)
let player = ref Player.new_player

(* Menu options *)
let base_menu = [ "View player stats"; "Pokemon Center"; "Exit" ]

(* Display main menu *)
let rec display_menu () =
  let menu =
    if List.length !player.team = 0 then
      "Choose your starter pokemon" :: base_menu
    else "Battle wild pokemon" :: base_menu
  in
  printf "\nMain Menu:\n";
  List.iteri (fun idx option -> printf "%d. %s\n" (idx + 1) option) menu;
  printf "> ";

  match read_line () with
  | "1" ->
      if List.length !player.team = 0 then choose_starter () else wild_battle ()
  | "2" ->
      printf "%s\n" (Player.player_to_string !player);
      display_menu ()
  | "3" -> pokemon_center ()
  | "4" -> exit 0
  | _ ->
      printf "Invalid choice. Please try again.\n";
      display_menu ()

(* Choose starter pokemon *)
and choose_starter () =
  printf "\nChoose your starter pokemon:\n";
  List.iteri
    (fun index (base_pokemon : Pokemon.base_pokemon) ->
      printf "%d. %s\n" (index + 1) base_pokemon.name)
    starters_base;
  printf "> ";

  match read_line () with
  | ("1" | "2" | "3") as choice ->
      let base_pokemon = List.nth starters_base (int_of_string choice - 1) in
      let starter_pokemon = Pokemon.create base_pokemon 5 in
      player := Player.add_team starter_pokemon !player;
      printf "You chose %s!\n" starter_pokemon.base.name;
      display_menu ()
  | _ ->
      printf "Invalid choice. Please try again.\n";
      choose_starter ()

(* Simulate a battle with a wild pokemon *)
and wild_battle () =
  let opponent_index = Random.int (List.length wild_pokemon_base) in
  let base_opponent = List.nth wild_pokemon_base opponent_index in
  let opponent = Pokemon.create_random base_opponent 5 in
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  printf "A wild %s appears!\n" opponent.base.name;

  let won = Battle.battle_loop player_pokemon opponent in
  if won then (
    let xp_gained = Pokemon.calculate_xp_gained opponent.level in
    let updated_pokemon = Pokemon.add_xp player_pokemon xp_gained in
    player := Player.update_pokemon updated_pokemon !player;
    printf "Your %s gained %d XP and is now Level %d.\n"
      updated_pokemon.base.name xp_gained updated_pokemon.level;
    let reward =
      let min_reward = 1 in
      let max_reward = 5 in
      let earned_coins =
        min_reward + Random.int (max_reward - min_reward + 1)
      in
      earned_coins
    in
    player := Player.adjust_coins reward !player;
    printf "You also won %d coins!\n" reward;
    printf "Do you want to add the wild %s to your team? (yes/no): "
      opponent.base.name;
    match String.lowercase_ascii (read_line ()) with
    | "yes" ->
        player := Player.add_team (Pokemon.copy_pokemon opponent) !player;
        printf "Added %s to your team.\n" opponent.base.name
    | "no" ->
        printf "You chose not to add %s to your team.\n" opponent.base.name
    | _ ->
        printf "Invalid choice. Not adding %s to your team.\n"
          opponent.base.name);
  display_menu ()

(* Go to Pokemon Center *)
and pokemon_center () =
  (if List.length !player.team = 0 then (
     printf "\nObtain a Pokemon first!\n";
     display_menu ())
   else
     let options = [ "Heal Pokemon"; "Exit" ] in
     printf "%s\n" (Player.player_to_string !player);
     printf "\nWelcome! What would you like to do?\n";
     List.iteri
       (fun index option -> printf "%d. %s\n" (index + 1) option)
       options;
     printf "> ";
     match read_line () with
     | "1" -> (
         printf "\nWhich Pokemon would you like to heal (cost: 2 coins)?\n";
         List.iteri
           (fun i x -> printf "%d. %s\n" (i + 1) (Pokemon.to_string x))
           !player.team;
         printf "%d. Exit\n" (List.length !player.team + 1);
         printf "> ";
         match read_int_opt () with
         | Some number when number > 0 && number <= List.length !player.team ->
             let selected = List.nth !player.team (number - 1) in
             if selected.hp = selected.base.max_hp then (
               printf "Pokemon is already at max hp! Select again.\n";
               pokemon_center ());
             if selected.feint then (
               selected.feint <- false;
               selected.hp <- selected.base.max_hp)
             else selected.hp <- selected.base.max_hp;
             player := Player.adjust_coins (-2) !player;
             printf "%s has been healed.\n" (Pokemon.name selected);
             pokemon_center ()
         | Some number when number = List.length !player.team + 1 ->
             pokemon_center ()
         | _ ->
             printf "Invalid choice. Please try again.\n";
             pokemon_center ())
     | "2" -> display_menu ()
     | _ ->
         printf "Invalid choice. Please try again.\n";
         pokemon_center ());
  display_menu ()

let () =
  Random.self_init ();
  display_menu ()
