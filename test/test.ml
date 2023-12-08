open OUnit2
open Mylib
open Pokemon
open Pokedex
open Player
open Battle

let squirtle1 = Pokemon.create base_squirtle 10
let charmander1 = Pokemon.create base_charmander 11

let player = ref (Player.new_player)


let init_tests =
 "suite" >::: [
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
   (fun _ -> assert_equal ~msg:"new_player team check" ~printer:string_of_int 0 (List.length new_player.team));
   "new_player current_pokemon check" >::
   (fun _ -> assert_equal ~msg:"new_player current_pokemon check" None new_player.current_pokemon);
   "new_player coins check" >::
   (fun _ -> assert_equal ~msg:"new_player coins check" 10 new_player.coins);
 ]

let battle_test =
  "suite" >::: [
    "wild battle" >:: (fun _ ->
      let player_pokemon = squirtle1 in
      let opponent_pokemon = Pokemon.create_random base_charmander 5 in

      player := { !player with current_pokemon = Some player_pokemon };

      let result = wild_battle_loop player_pokemon opponent_pokemon !player in

      assert_bool "Player Victory" result;
      assert_equal ~msg:"XP Increase" ~printer:string_of_int 0 (fst player_pokemon.xp) |> ignore;
      assert_equal ~msg:"Coin Change" ~printer:string_of_int 10
        !player.coins;
      assert_equal ~msg:"Updated HP" ~printer:string_of_bool
        true (player_pokemon.hp <= player_pokemon.current_max_hp);
    );
  ]

let () =
 run_test_tt_main init_tests;
 (* run_test_tt_main battle_test; *)