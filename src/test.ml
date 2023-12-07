open OUnit2
open Pokemon
open Pokedex




let squirtle1 = Pokemon.create base_squirtle 10
let charmander1 = Pokemon.create base_charmander 11


let tests =
 "suite" >::: [
   "hp check" >::
   (fun _ -> assert_equal ~msg:"hp check" squirtle1.hp 10);
   "hp check" >::
   (fun _ -> assert_equal ~msg:"hp check" squirtle1.level 10);
 ]


let () =
 run_test_tt_main tests
