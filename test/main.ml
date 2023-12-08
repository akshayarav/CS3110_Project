open OUnit2
open Mylib
open Pokemon
open Pokedex
let squirtle1 = Pokemon.create base_squirtle 10

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
          let new_pokemon, updated_player = Battle.choose_new_pokemon player in
          simulate_battle new_pokemon opponent_pokemon updated_player
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
              let new_pokemon, updated_player = Battle.choose_new_pokemon player in
              simulate_battle new_pokemon opponent_pokemon updated_player
          else
            battle_loop player_pokemon opponent_pokemon player
        )
      )
    in
    battle_loop player_pokemon opponent_pokemon player  
let init_tests = "Test Suite for Pokemon" >::: [
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
  (fun _ -> assert_equal ~msg:"base check" base_squirtle squirtle1.base);

  "new_player team check" >::
  (fun _ -> assert_equal ~msg:"new_player team check" ~printer:string_of_int 0 (List.length Player.new_player.team));
  "new_player current_pokemon check" >::
  (fun _ -> assert_equal ~msg:"new_player current_pokemon check" None Player.new_player.current_pokemon);
  "new_player coins check" >::
  (fun _ -> assert_equal ~msg:"new_player coins check" 10 Player.new_player.coins);
]

let battle_tests =
  "suite" >::: [
    "wild battle" >:: (fun _ ->
      let player_pokemon = squirtle1 in
      let opponent_pokemon = Pokemon.create_random base_charmander 5 in

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
      let opponent_pokemon = Pokemon.create base_charmander 5 in

      player := { !player with current_pokemon = Some player_pokemon };

      let result = simulate_battle player_pokemon opponent_pokemon !player in

      assert_equal ~printer:string_of_bool result true;
    );
  ]

  let all_tests = "All Tests" >::: [
    init_tests;
    battle_tests;
  ]
  
  let () =
    run_test_tt_main all_tests
  