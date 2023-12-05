(* File to start the UI  *)
open Printf
open Pokedex
open Player
open Pokemon

let handle_new_moves pokemon =
  let new_moves = Pokemon.check_new_moves pokemon in
  List.fold_left
    (fun acc_pokemon (_, new_move) ->
      (* Extract just the move from each tuple *)
      if List.length acc_pokemon.base.moves < 4 then
        (* If less than 4 moves, learn directly without replacing *)
        Pokemon.learn_move acc_pokemon new_move (-1)
      else
        (* Randomly select a move to be replaced *)
        let move_to_replace = Random.int (List.length acc_pokemon.base.moves) in
        Printf.printf "%s learns the move %s, replacing %s.\n"
          acc_pokemon.base.name new_move.name
          (List.nth acc_pokemon.base.moves move_to_replace).name;
        Pokemon.learn_move acc_pokemon new_move move_to_replace)
    pokemon new_moves

(* Prints if pokemon can evolve *)
let handle_evolution pokemon =
  match Pokemon.check_evolution pokemon with
  | Some evolved_form ->
      printf "%s is evolving into %s!\n" pokemon.base.name evolved_form.name;
      (* Add any user interaction if needed *)
      Pokemon.evolve_pokemon pokemon evolved_form
  | None -> pokemon

(* Stores the player *)
let player = ref Player.new_player

(* Menu options *)
let base_menu = [ "View player stats"; "Pokemon Center"; "Exit" ]

(* Modify the display_menu function to include the Elite Four option *)
let rec display_menu () =
  let menu =
    if List.length !player.team = 0 then
      "Choose your starter pokemon" :: base_menu
    else "Battle wild pokemon" :: "Battle the Elite Four" :: base_menu
  in
  printf "\nMain Menu:\n";
  List.iteri (fun idx option -> printf "%d. %s\n" (idx + 1) option) menu;
  printf "> ";

  match read_line () with
  | "1" ->
      if List.length !player.team = 0 then choose_starter () else wild_battle ()
  | "2" ->
      if List.length !player.team > 0 then elite_four_battle ()
      else (printf "%s\n" (Player.player_to_string !player); display_menu ())
  | "3" ->
      if List.length !player.team > 0 then (printf "%s\n" (Player.player_to_string !player); display_menu ())
      else pokemon_center ()
  | "4" ->
      if List.length !player.team > 0 then pokemon_center ()
      else exit 0
  | "5" -> exit 0
  | _ ->
      printf "Invalid choice. Please try again.\n";
      display_menu ()

and elite_four_battle () =
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  let result = Array.fold_left (fun acc member ->
    if not acc then acc (* If the player has already lost, skip the remaining battles *)
    else
      match member.Trainer.team with
      | [] -> false (* No Pokémon in Elite member's team, player wins by default *)
      | opponent_pokemon :: _ ->  (* Take the first Pokémon from the member's team *)
          Printf.printf "You are now battling Elite Four member %s!\n" member.Trainer.name;
          let won = Battle.trainer_battle_loop player_pokemon opponent_pokemon !player member in
          if won then (
            Printf.printf "You defeated %s!\n" member.Trainer.name;
            true (* Continue to the next member *)
          ) else (
            Printf.printf "You lost to %s. Better luck next time!\n" member.Trainer.name;
            false (* Player lost, end the Elite Four challenge *)
          )
  ) true Alltrainers.elite_four in

  if result then Printf.printf "Congratulations! You have defeated the Elite Four!\n";
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
      let new_player, _ = Player.add_team starter_pokemon !player in
      player := new_player;
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

  let won = Battle.wild_battle_loop player_pokemon opponent !player in
  if won then (
    let xp_gained = Pokemon.calculate_xp_gained opponent.level in
    let updated_pokemon = Pokemon.add_xp player_pokemon xp_gained in
    printf "Your %s gained %d XP.\n" updated_pokemon.base.name xp_gained;

    (* Check if the Pokémon leveled up *)
    if updated_pokemon.level > player_pokemon.level then (
      printf "Your %s grew to Level %d!\n" updated_pokemon.base.name
        updated_pokemon.level;

      (* Handle new moves *)
      let pokemon_after_moves = handle_new_moves updated_pokemon in

      (* Handle evolution *)
      let evolved_pokemon = handle_evolution pokemon_after_moves in

      (* Update player's pokemon *)
      player := Player.update_pokemon evolved_pokemon !player;

      if evolved_pokemon.base.name <> player_pokemon.base.name then
        printf "What? %s is evolved into %s!\n" player_pokemon.base.name
          evolved_pokemon.base.name)
    else
      (* If no level up, just update the Pokémon *)
      player := Player.update_pokemon updated_pokemon !player;

    printf "Do you want to add the wild %s to your team? (yes/no): " opponent.base.name;
    match String.lowercase_ascii (read_line ()) with
    | "yes" ->
        let (new_player, was_added) = Player.add_team (Pokemon.copy_pokemon opponent) !player in
        player := new_player;
        if was_added then
          printf "Added %s to your team.\n" opponent.base.name
        else
          printf "%s was not added to your team.\n" opponent.base.name
    | "no" ->
        printf "You chose not to add %s to your team.\n" opponent.base.name
    | _ ->
        let name = opponent.base.name in
        printf "Invalid choice. Not adding %s to your team.\n" name
  );
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
           (fun i pokemon ->
             printf "%d. %s (Current HP: %d)\n" (i + 1) (Pokemon.to_string pokemon) pokemon.hp)
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