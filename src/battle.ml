open Printf
open Pokemon
open Trainer

let on_move_chosen (move: move option) player_pokemon opponent update_ui next_turn_ui (result) =
  (* Here you would add the logic to apply the move, like reducing HP, etc. *)
  let process_move (move: move option) = 
    match move with 
    | Some chosen_move ->
        update_ui (sprintf "%s used %s!\n" (Pokemon.name player_pokemon) chosen_move.name);
        Pokemon.attack chosen_move opponent player_pokemon;  (* Apply player's chosen move *)
        let ai_move = Ai.choose_move opponent in
        update_ui (sprintf "%s used %s!\n" (Pokemon.name opponent) ai_move.name);
        Pokemon.attack ai_move player_pokemon opponent;
    | None -> failwith "Switching pokemon unimplemented"; 
    in
  process_move move;
  update_ui (sprintf "\nYour %s's HP: %d\n" player_pokemon.base.name player_pokemon.hp);
  update_ui (sprintf "%s's HP: %d\n" (Pokemon.name opponent) opponent.hp);
  (* Check if the battle is over and handle accordingly *)
  let continue = ref true in
  if player_pokemon.hp <= 0 then (
    update_ui "Your Pokemon fainted!";
    result false;
    continue := false;
  )
  else if opponent.hp <= 0 then (
    update_ui (sprintf"%s defeated %s!" (Pokemon.name player_pokemon) (Pokemon.name opponent));
    result true;
    continue := false;
  );
  if !continue then next_turn_ui else ()

let update_trainer_team (trainer: trainer) (new_team: pokemon list) =
  { trainer with team = new_team }