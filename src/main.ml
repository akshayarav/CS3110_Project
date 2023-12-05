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
    else
      [
        "Battle wild pokemon";
        "Battle the Elite Four";
        "Practice against trainer";  (* New option for practice battles *)
      ]
      @ base_menu
      in
      printf "\nMain Menu:\n";
      List.iteri (fun idx option -> printf "%d. %s\n" (idx + 1) option) menu;
      printf "> ";

      let choice = read_line () in

      match choice with
      | "1" ->
        if List.length !player.team = 0 then choose_starter () else wild_battle ()
      | "2" ->
          if List.length !player.team > 0 then elite_four_battle ()
          else (printf "%s\n" (Player.player_to_string !player); display_menu ())
      | "3" -> (* Practice against trainer *)
      if List.length !player.team > 0 then practice_trainer_battle ()
      else begin
        printf "%s\n" (Player.player_to_string !player);
        display_menu ()
      end
      | "4" ->
        if List.length !player.team > 0 then (printf "%s\n" (Player.player_to_string !player); display_menu ())
        else pokemon_center ()
      | "5" -> (* Pokemon Center *)
          pokemon_center ()
      | "6" -> exit 0
      | _ ->
          printf "Invalid choice. Please try again.\n";
          display_menu ()

and choose_reward pokemon_list =
  (* Define a function to take n elements from a list *)
  let rec take_n n lst acc =
    if n = 0 then
      acc
    else
      match lst with
      | [] -> acc
      | hd :: tl -> take_n (n - 1) tl (hd :: acc)
  in

  (* Shuffle the list to randomize the order *)
  let shuffled_pokemon_list = List.sort (fun _ _ -> if Random.bool () then 1 else -1) pokemon_list in

  (* Select the first three Pokémon from the shuffled list *)
  let chosen_pokemon_list = take_n 3 shuffled_pokemon_list [] in

  let rec choose_pokemon () =
    Printf.printf "Choose a Pokémon:\n";

    (* Iterate over the chosen_pokemon_list to print options *)
    List.iteri (fun index pokemon ->
      Printf.printf "%d. %s\n" (index + 1) pokemon.name
    ) chosen_pokemon_list;

    Printf.printf "Enter the number of the Pokémon you want to choose: ";
    try
      let choice = int_of_string (read_line ()) in
      if choice >= 1 && choice <= List.length chosen_pokemon_list then
        let chosen_pokemon = List.nth chosen_pokemon_list (choice - 1) in
        Printf.printf "You chose %s!\n" chosen_pokemon.name;

        (* Create a new Pokémon using Pokemon.create *)
        let new_pokemon = Pokemon.create chosen_pokemon 30 in

        (* Add the chosen Pokémon to the player's team or swap it *)
        let (updated_player, added_or_swapped) = add_team new_pokemon !player in
        player := updated_player;
        if added_or_swapped then
          Printf.printf "Added %s to your team!\n" chosen_pokemon.name
        else
          Printf.printf "No change to your team.\n";

        display_menu ()
      else begin
        Printf.printf "Invalid choice. Please enter a number between 1 and %d.\n" (List.length chosen_pokemon_list);
        choose_pokemon ()
      end
    with
    | Failure _ ->
      Printf.printf "Invalid input. Please enter a number.\n";
      choose_pokemon ()
  in

  choose_pokemon ()

and elite_four_battle () =
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in

  let rec battle_through_elite_four (elite_four_members : Trainer.trainer list) =
    match elite_four_members with
    | [] ->
        Printf.printf "Congratulations! You have defeated the Elite Four!\n";
        true
    | member :: rest ->
        Printf.printf "You are now battling Elite Four member %s!\n" member.name;
        let won = Battle.trainer_battle_loop player_pokemon member.current_pokemon !player member in
        if won then (
          Printf.printf "You defeated %s!\n" member.name;
          battle_through_elite_four rest
        ) else (
          Printf.printf "You lost to %s. Better luck next time!\n" member.name;
          false
        )
  in

  let elite_four_members : Trainer.trainer list = Array.to_list (Trainer.create_elite_four ()) in
  let result = battle_through_elite_four elite_four_members in

  if result then display_menu ()
  else Printf.printf "Try challenging the Elite Four again when you're ready!\n";
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
  | ("1" | "2" | "3" | "4") as choice ->
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
    let reward =
      let min_reward = 1 in
      let max_reward = 5 in
      let earned_coins = min_reward + Random.int (max_reward - min_reward + 1) in
      earned_coins
    in
    player := Player.adjust_coins reward !player;
    printf "You also won %d coins!\n" reward;
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

and practice_trainer_battle () =
  (* Generate the array of regular trainers *)
  let regular_trainers = Trainer.create_regular_trainers () in

  (* Randomly select a trainer from regular_trainers *)
  let trainer_index = Random.int (Array.length regular_trainers) in
  let trainer = regular_trainers.(trainer_index) in

  Printf.printf "You are practicing against Trainer %s!\n" trainer.name;

  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in

  let result = Battle.trainer_battle_loop player_pokemon trainer.current_pokemon !player trainer in

  if result then begin
    Printf.printf "Congratulations! You defeated Trainer %s!\n" trainer.name;

    (* Adjust the player's coins *)
    player := Player.adjust_coins 50 !player;
    Printf.printf "You earned 50 coins. Total coins: %d\n" !player.coins;

    (* Award experience points to all Pokémon on the player's team *)
    let xp_gained = Pokemon.calculate_xp_gained trainer.current_pokemon.level in
    player := {
      !player with
      team = List.map (fun pkmn -> Pokemon.add_xp pkmn xp_gained) !player.team
    };
    Printf.printf "All your team Pokémon gained %d XP.\n" xp_gained;

    choose_reward Pokedex.reward_pokemon_base

  end else begin
    Printf.printf "You lost to Trainer %s. Better luck next time!\n" trainer.name;
    display_menu ()
  end


(* Go to Pokemon Center *)
and pokemon_center () =
  if List.length !player.team = 0 then (
    printf "\nObtain a Pokemon first!\n";
    display_menu ()
  ) else (
    let options = [ "Heal All Pokemon"; "Purchase Legendary Pokemon"; "Exit" ] in
    printf "%s\n" (Player.player_to_string !player);
    printf "\nWelcome! What would you like to do?\n";
    List.iteri (fun index option -> printf "%d. %s\n" (index + 1) option) options;
    printf "> ";
    match read_line () with
    | "1" -> (
        let healable_pokemon = List.filter (fun p -> p.hp < p.current_max_hp) !player.team in
        let total_cost = 2 * List.length healable_pokemon in
        if total_cost > !player.coins then (
          printf "Not enough coins to heal all Pokemon.\n";
          pokemon_center ()
        ) else (
          List.iter (fun pokemon ->
            if pokemon.hp < pokemon.current_max_hp then (
              pokemon.hp <- pokemon.current_max_hp;
              pokemon.feint <- false
            )
          ) !player.team;
          player := Player.adjust_coins (-total_cost) !player;
          printf "All injured Pokemon have been healed.\n";
          pokemon_center ()
        )
      )
    | "2" ->
      printf "\nPurchase a Legendary Pokemon for 100 coins.\n";
      if !player.coins < 100 then (
        printf "Not enough coins.\n";
        pokemon_center ()
      ) else (
        choose_reward Pokedex.legendary_pokemon_base;
      )
    | "3" -> display_menu ()
    | _ ->
        printf "Invalid choice. Please try again.\n";
        pokemon_center ()
  );
  display_menu ()

let () =
  Random.self_init ();
  display_menu ()