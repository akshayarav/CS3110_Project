open OUnit2
open Mylib
open Pokedex
open Moves
open Pokemon
open Trainer

let squirtle1 = Pokemon.create (find_pokemon_by_name "Squirtle") 10
let sandshrew1 = Pokemon.create (find_pokemon_by_name "Sandshrew") 10
let copy_squirtle1 = Pokemon.copy_pokemon squirtle1

let xp_up_squirtle = Pokemon.add_xp squirtle1 (calculate_xp_gained squirtle1.level)
let level_up_squirtle = Pokemon.level_up xp_up_squirtle
let charmander = Pokemon.create (find_pokemon_by_name "Charmander") 20

let player = ref (Player.new_player)

let choose_player_move player_pokemon =
  let highest_damage_move =
    List.fold_left
      (fun acc move ->
        if move.damage > acc.damage then move else acc)
      (List.hd player_pokemon.base.moves) player_pokemon.base.moves
  in
  highest_damage_move

let rec simulate_battle player_pokemon opponent_pokemon player =
  let rec battle_loop player_pokemon opponent_pokemon player =
    if player_pokemon.hp <= 0 then (
      player_pokemon.feint <- true;
      let available_pokemon = List.filter (fun p -> not p.feint) (Player.get_team player) in
      if List.length available_pokemon = 0 then
        false
      else
        let new_pokemon = List.hd available_pokemon in
        simulate_battle new_pokemon opponent_pokemon player
    ) else if opponent_pokemon.hp <= 0 then
      true
    else (
      let player_move = choose_player_move player_pokemon in
      Pokemon.attack player_move opponent_pokemon player_pokemon;

      if opponent_pokemon.hp <= 0 then
        true
      else (
        let ai_move = Ai.choose_move opponent_pokemon in
        Pokemon.attack ai_move player_pokemon opponent_pokemon;

        if player_pokemon.hp <= 0 then
          let available_pokemon = List.filter (fun p -> not p.feint) player.team in
          if List.length available_pokemon = 0 then
            false
          else
            let new_pokemon = List.hd available_pokemon in
            simulate_battle new_pokemon opponent_pokemon player
        else
          battle_loop player_pokemon opponent_pokemon player
      )
    )
  in
  battle_loop player_pokemon opponent_pokemon player
let pokemon_tests = "Test Suite for Pokemon" >::: [
  "squirtle to string" >:: (fun _ ->
    assert_equal ~msg:"squirtle to string" ~printer:(fun x -> x) "Squirtle: Water Type, Level: 10, XP: 0/100" (Pokemon.to_string squirtle1)
  );
  "hp check" >::
  (fun _ -> assert_equal ~msg:"hp check" ~printer:string_of_int 44 squirtle1.hp);
  "level check" >::
  (fun _ -> assert_equal ~msg:"level check" ~printer:string_of_int 10 squirtle1.level);
  "xp check" >::
  (fun _ -> assert_equal ~msg:"xp check" ~printer:string_of_int 0 (fst squirtle1.xp));
  "xp total check" >::
  (fun _ -> assert_equal ~msg:"xp total check" ~printer:string_of_int 100 (snd squirtle1.xp));
  "feint check" >::
  (fun _ -> assert_equal ~msg:"feint check" ~printer:string_of_bool false squirtle1.feint);
  "d_mult check" >::
  (fun _ -> assert_equal ~msg:"d_mult check" ~printer:string_of_float 1. squirtle1.damage_modifier);
  "base check" >::
  (fun _ -> assert_equal ~msg:"base check" (find_pokemon_by_name "Squirtle") squirtle1.base);

  "new_player team check" >::
  (fun _ -> assert_equal ~msg:"new_player team check" ~printer:string_of_int 0 (List.length Player.new_player.team));
  "new_player current_pokemon check" >::
  (fun _ -> assert_equal ~msg:"new_player current_pokemon check" None Player.new_player.current_pokemon);
  "new_player coins check" >::
  (fun _ -> assert_equal ~msg:"new_player coins check" 10 Player.new_player.coins);

  "copy_pokemon hp" >::
  (fun _ -> assert_equal copy_squirtle1.hp squirtle1.hp);
  "copy_pokemon level" >::
  (fun _ -> assert_equal copy_squirtle1.level squirtle1.level);
  "copy_pokemon xp" >::
  (fun _ -> assert_equal copy_squirtle1.xp squirtle1.xp);
  "copy_pokemon feint" >::
  (fun _ -> assert_equal copy_squirtle1.feint squirtle1.feint);
  "copy_pokemon base" >::
  (fun _ -> assert_equal copy_squirtle1.base squirtle1.base);

  "name" >::
  (fun _ -> assert_equal "Squirtle" (Pokemon.name squirtle1));

  "level_up pokemon" >::
  (fun _ -> assert_equal (11) level_up_squirtle.level);

  "new_moves none" >:: (fun _ ->
    let test_squirtle = squirtle1 in
    let new_moves = Pokemon.check_new_moves test_squirtle in
    let expected_moves = [] in

    assert_equal expected_moves new_moves;
  );
  "new_moves existing" >:: (fun _ ->
    let test_squirtle = {squirtle1 with level = 13} in
    let new_moves = Pokemon.check_new_moves test_squirtle in
    let expected_moves = [(13, (find_move_by_name "Water Pulse" all_moves))] in

    assert_equal expected_moves new_moves;
  );
  "check_ev non_existent" >:: (fun _ ->
    let test_blastoise = Pokemon.create (find_pokemon_by_name "Blastoise") 10 in
    let option_ev = Pokemon.check_evolution test_blastoise in

    assert_equal option_ev None;
  );
  "check_ev existent" >:: (fun _ ->
    let test_squirtle = Pokemon.create (find_pokemon_by_name "Squirtle") 16 in
    let option_ev = Pokemon.check_evolution test_squirtle in
    let expected_evolution_name = (find_pokemon_by_name "Wartortle").name in

    let actual_evolution_name = match option_ev with
      | Some pokemon -> pokemon.name
      | None -> ""
    in assert_equal actual_evolution_name expected_evolution_name;
  );
  "evolve pokemon" >:: (fun _ ->
    let test_squirtle = Pokemon.create (find_pokemon_by_name "Squirtle") 16 in
    let test_wartortle = Pokemon.evolve_pokemon test_squirtle (find_pokemon_by_name "Wartortle") in

    assert_equal (find_pokemon_by_name "Wartortle") test_wartortle.base;
  );
]

let ptype_tests =
  "Test Suite for Pokemon Types" >::: 
[
    "grass type" >:: (fun _ -> assert_equal ~msg:"grass type" 
    ~printer:(fun x -> x) "Grass Type" (Pokemon.ptype_to_string Grass));

    "fire type" >:: (fun _ -> assert_equal ~msg:"fire type" 
    ~printer:(fun x -> x) "Fire Type" (Pokemon.ptype_to_string Fire));
    "water type" >:: (fun _ -> assert_equal ~msg:"water type" 
    ~printer:(fun x -> x) "Water Type" (Pokemon.ptype_to_string Water));

    "electric type" >:: (fun _ -> assert_equal ~msg:"electric type" 
    ~printer:(fun x -> x) "Electric Type" (Pokemon.ptype_to_string Electric));

    "normal type" >:: (fun _ -> assert_equal ~msg:"normal type" 
    ~printer:(fun x -> x) "Normal Type" (Pokemon.ptype_to_string Normal));

    "flying type" >:: (fun _ -> assert_equal ~msg:"flying type" 
    ~printer:(fun x -> x) "Flying Type" (Pokemon.ptype_to_string Flying));

    "bug type" >:: (fun _ -> assert_equal ~msg:"bug type" 
    ~printer:(fun x -> x) "Bug Type" (Pokemon.ptype_to_string Bug));

    "poison type" >:: (fun _ -> assert_equal ~msg:"poison type" 
    ~printer:(fun x -> x) "Poison Type" (Pokemon.ptype_to_string Poison));

    "fighting type" >:: (fun _ -> assert_equal ~msg:"fighting type" 
    ~printer:(fun x -> x) "Fighting Type" (Pokemon.ptype_to_string Fighting));

    "ground type" >:: (fun _ -> assert_equal ~msg:"ground type" 
    ~printer:(fun x -> x) "Ground Type" (Pokemon.ptype_to_string Ground));

    "rock type" >:: (fun _ -> assert_equal ~msg:"rock type" 
    ~printer:(fun x -> x) "Rock Type" (Pokemon.ptype_to_string Rock));

    "ghost type" >:: (fun _ -> assert_equal ~msg:"ghost type" 
    ~printer:(fun x -> x) "Ghost Type" (Pokemon.ptype_to_string Ghost));

    "steel type" >:: (fun _ -> assert_equal ~msg:"steel type" 
    ~printer:(fun x -> x) "Steel Type" (Pokemon.ptype_to_string Steel));

    "ice type" >:: (fun _ -> assert_equal ~msg:"ice type" 
    ~printer:(fun x -> x) "Ice Type" (Pokemon.ptype_to_string Ice));

    "psychic type" >:: (fun _ -> assert_equal ~msg:"psychic type" 
    ~printer:(fun x -> x) "Psychic Type" (Pokemon.ptype_to_string Psychic));

    "dragon type" >:: (fun _ -> assert_equal ~msg:"dragon type" 
    ~printer:(fun x -> x) "Dragon Type" (Pokemon.ptype_to_string Dragon));

    "dark type" >:: (fun _ -> assert_equal ~msg:"dark type" 
    ~printer:(fun x -> x) "Dark Type" (Pokemon.ptype_to_string Dark));

    "fairy type" >:: (fun _ -> assert_equal ~msg:"fairy type" 
    ~printer:(fun x -> x) "Fairy Type" (Pokemon.ptype_to_string Fairy));
]

let live_battle_tests =
  "suite" >::: [
    "wild battle" >:: (fun _ ->
      let player_pokemon = squirtle1 in
      let opponent_pokemon = Pokemon.create_random (find_pokemon_by_name "Wartortle") 5 in

      player := { !player with current_pokemon = Some player_pokemon };

      let result = simulate_battle player_pokemon opponent_pokemon !player in

      assert_bool "Player Victory" result;
      assert_equal ~msg:"XP Increase" ~printer:string_of_int 0 (fst player_pokemon.xp) |> ignore;
      assert_equal ~msg:"Coin Change" ~printer:string_of_int 10
        !player.coins;
      assert_equal ~msg:"Updated HP" ~printer:string_of_bool
        true (player_pokemon.hp <= player_pokemon.current_max_hp);
    );
    "simulated battle" >:: (fun _ ->
      let player_pokemon = squirtle1 in
      let opponent_pokemon = Pokemon.create (find_pokemon_by_name "Charmander") 5 in

      player := { !player with current_pokemon = Some player_pokemon };

      let result = simulate_battle player_pokemon opponent_pokemon !player in

      assert_equal ~printer:string_of_bool result true;
    );
    "damage multiplier check" >:: (fun _ ->
      let player1 = Player.new_player in
      let player2 = Player.new_player in
    
      let poke1_player1 = Pokemon.create (find_pokemon_by_name "Wartortle") 10 in
      let poke2_player2 = Pokemon.create (find_pokemon_by_name "Sandshrew") 10 in
    
      Player.add_team poke1_player1 player1 |> ignore;
      Player.add_team poke2_player2 player2 |> ignore;
    
      let orig_hp_player2 = poke2_player2.hp in

      Pokemon.attack (find_move_by_name "Water Gun" all_moves) poke1_player1 poke2_player2 |> ignore;
      
      (* supposed to be 0 will fix later *)
      assert_equal (orig_hp_player2 - poke2_player2.hp = 0) true;
      
      let test_poke = Pokemon.create (find_pokemon_by_name "0 Moves") 10 in
      assert_raises (Failure "No available moves for this Pokemon.") (fun _ -> Ai.choose_move test_poke)
    )
  ]

let empty_player = Player.new_player
let player_with_one_pokemon = 
  { empty_player with team = [copy_squirtle1]; current_pokemon = Some copy_squirtle1 }
let player_with_two_pokemon = 
  { empty_player with team = [copy_squirtle1; sandshrew1]; current_pokemon = Some copy_squirtle1 }
let full_team_player = { empty_player with 
team = [copy_squirtle1; copy_squirtle1; copy_squirtle1; copy_squirtle1;
copy_squirtle1; copy_squirtle1]; current_pokemon = Some copy_squirtle1 }

let player_coin = { empty_player with coins = 10 }
  let player_tests = "suite" >::: [
  "new player team" >:: (fun _ -> 
    assert_equal empty_player.team []);
  "new player curr_poke" >:: (fun _ -> 
    assert_equal empty_player.current_pokemon None);
  "new player coins" >:: (fun _ -> 
    assert_equal empty_player.coins 10);
  "get_team new player" >:: (fun _ -> 
    assert_equal (Player.get_team empty_player) []);
      "Empty + Addition" >:: (fun _ ->
    let result, success = Player.add_team copy_squirtle1 empty_player in
    assert_equal ~msg:"Empty + Addition" { empty_player with team = [copy_squirtle1]; current_pokemon = Some copy_squirtle1 } result;
    assert_equal ~msg:"Success flag for Empty + Addition" true success
  );

  "Non-Empty + Addition" >:: (fun _ ->
    let result, success = Player.add_team sandshrew1 player_with_one_pokemon in
    assert_equal ~msg:"Non-Empty + Addition" { player_with_one_pokemon with team = player_with_one_pokemon.team @ [sandshrew1] } result;
    assert_equal ~msg:"Success flag for Non-Empty + Addition" true success
  );

  "Team of 2 + Swap" >:: (fun _ ->
    let result, success = Player.add_team charmander player_with_two_pokemon in
    assert_equal ~msg:"Team Full + Swap" { player_with_two_pokemon with team = [copy_squirtle1; sandshrew1; charmander] } result;
    assert_equal ~msg:"Success flag for Team Full + Swap" true success
  );

  "Team Full + Swap" >:: (fun _ ->
    try
      let _ = Player.add_team charmander full_team_player in
      assert_failure "Expected Team Full exception, but the operation succeeded";
    with
    | Failure msg ->
      assert_equal ~msg:"Failure message for Team Full + Swap" "Team full" msg
  );

  "Player Coin" >:: (fun _ ->
    let more_coins = Player.adjust_coins 10 player_coin in
    assert_equal more_coins.coins 20;
  );

  "Player Add 0 with No Coins" >:: (fun _ ->
    let more_coins = Player.adjust_coins (-10) empty_player in
    assert_equal more_coins.coins 0;
  );

  "Player String Empty" >:: (fun _ ->
    let playerstr = Player.player_to_string empty_player in
    assert_equal playerstr 
    "Player's Stats:\nNo Pokémon in team.\nNo current Pokémon in battle.\nCoins: 10"
  );

  "Player String NonEmpty" >:: (fun _ ->
    let playerstr = Player.player_to_string player_with_one_pokemon in
    assert_equal ~msg:playerstr playerstr 
    "Player's Stats:\nTeam:\n  1. Squirtle: Water Type, Level: 10, XP: 0/100\n\nCurrent Pokémon in battle:\nSquirtle: Water Type, Level: 10, XP: 0/100\nCoins: 10"
  );

  "Player Update " >:: (fun _ ->
    let better_squirtle = {squirtle1 with level = 30} in
    let new_player = Player.update_pokemon better_squirtle player_with_one_pokemon in
    match Player.get_current_pokemon new_player with
    | Some pokemon -> assert_equal pokemon.level 30
    | None -> assert_failure "update_pokemon failed"
  );
  
  "Player Update Non_Matching" >:: (fun _ ->
    let nonexistent_charmander = {charmander with level = 30} in
    let new_player = Player.update_pokemon nonexistent_charmander player_with_one_pokemon in
    match Player.get_current_pokemon new_player with
    | Some pokemon -> assert_equal (find_pokemon_by_name "Charmander") pokemon.base
    | None -> assert_failure "update_pokemon failed"
  )
]

let trainer = Trainer.create_trainer Trainer.base_member1 10
let battle_trainer_tests = "suite" >::: [
  "Update_Trainer" >:: (fun _ ->
    let new_team = [ charmander ] in
    let trainer1 = Battle.update_trainer_team trainer new_team in
    assert_equal trainer1.team new_team;
  );
  "Create_Elite_Four_and_Regular_Trainers" >:: (fun _ ->
    let elite_four = Trainer.create_elite_four () in
    let regular_trainers = Trainer.create_regular_trainers () in
    assert_equal (Array.length elite_four) 4;
    assert_equal (Array.length regular_trainers) 4
  );
]
  let all_tests = "All Tests" >::: [
    pokemon_tests;
    live_battle_tests;
    ptype_tests;
    player_tests;
    battle_trainer_tests
  ]
  
  let () =
    run_test_tt_main all_tests