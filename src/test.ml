open OUnit2
open Pokemon
open Pokedex

let squirtle1 = Pokemon.create base_squirtle 10
let charmander1 = Pokemon.create base_charmander 11

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
 ]

let battle_test =
  "suite" >::: [
    (* "hp check" >::
    (fun _ -> assert_equal ~msg:"hp check" ~printer:string_of_int 44 33); *)
  ]
let () =
 run_test_tt_main init_tests;
 (* run_test_tt_main battle_test *)
