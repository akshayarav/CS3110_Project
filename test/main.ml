open OUnit2
open Mylib
open Pokemon
open Pokedex
open Player
(* open Battle *)

let squirtle1 = Pokemon.create base_squirtle 10
(* let charmander1 = Pokemon.create base_charmander 11 *)

(* let player = ref (Player.new_player) *)

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
  (fun _ -> assert_equal ~msg:"new_player team check" ~printer:string_of_int 0 (List.length new_player.team));
  "new_player current_pokemon check" >::
  (fun _ -> assert_equal ~msg:"new_player current_pokemon check" None new_player.current_pokemon);
  "new_player coins check" >::
  (fun _ -> assert_equal ~msg:"new_player coins check" 10 new_player.coins);
]
  
  (* let battle_tests = "Battle Tests" >::: [
    "wild battle" >:: (fun _ ->
      (* ... battle test code ... *)
    );
    (* ... other battle tests ... *)
  ]
   *)


  let all_tests = "All Tests" >::: [
    init_tests;
    (* battle_tests; *)
  ]
  
  let () =
    run_test_tt_main all_tests
  