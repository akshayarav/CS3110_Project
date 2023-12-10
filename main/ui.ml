open Mylib
open Printf
open Moves

let main_menu : (GWindow.window option) ref = ref None

let get_main_menu () = 
  match !main_menu with 
  | Some (window) -> window
  | None -> failwith "No window"

let player = ref Player.new_player
let starters_base = Pokedex.starters_base
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
    | None -> failwith "Swapping Unimplemented" ; 
    in
  process_move move;
  update_ui (sprintf "\nYour %s's HP: %d\n" player_pokemon.base.name player_pokemon.hp);
  update_ui (sprintf "%s's HP: %d\n" (Pokemon.name opponent) opponent.hp);
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

let update_ui_string dialog message =
  let label = GMisc.label ~text:message () in
  ignore (dialog#vbox#add (label :> GObj.widget));

  dialog#show ()

let clear_container container = (
  let children = container#all_children in
  List.iter (fun widget ->
    container#remove widget;
  ) children; )

let create_ok_button dialog = (
  let ok_button = GButton.button ~label:"OK" ~packing:dialog#vbox#add () in

  ignore (
    ok_button#connect#clicked ~callback:(fun () ->
      dialog#destroy (); 
    )
  );)

let message_ui parent_window message = (
  let dialog = GWindow.message_dialog 
    ~message 
    ~parent:parent_window
    ~destroy_with_parent:true
    ~message_type:`INFO
    ~buttons:GWindow.Buttons.ok 
    ~modal:true 
    () in

  (* Run the dialog and capture the response *)
  let _ = dialog#run () in

  (* Destroy the dialog after the user responds *)
  dialog#destroy ();)

let raise_error_ui parent_window message = (
  let dialog = GWindow.message_dialog 
    ~message 
    ~parent:parent_window
    ~destroy_with_parent:true
    ~message_type:`ERROR
    ~buttons:GWindow.Buttons.ok 
    ~modal:true 
    () in

  let _ = dialog#run () in

  dialog#destroy ();)

let swap_team par func opponent result= (
  let dialog = GWindow.dialog
  ~title:"Choose a Pokemon to Swap"
  ~parent: par
  ~width:500
  ~height:300
  ~destroy_with_parent:true
  ~modal:true
  () in
  let vbox = GPack.vbox ~packing:dialog#vbox#add () in



  let swap_current pokemon = 
    player := {!player with current_pokemon = Some pokemon};
    let player_pokemon =
      match !player.current_pokemon with
      | Some p -> p
      | None -> failwith "No current Pokémon to battle with"
    in
    func par player_pokemon.base.moves player_pokemon opponent result in

  List.iter (fun (p) ->
    let button = GButton.button
      ~label:(sprintf "%s" (Pokemon.name p))
      ~packing:vbox#add () in

    ignore(button#connect#clicked ~callback:(fun _ -> dialog#destroy (); swap_current p;));
  ) (Player.get_team !player); 
  dialog#show ())
  

let rec update_ui_moves dialog moves player_pokemon opponent result = (
  clear_container dialog#vbox;
  update_ui_string dialog (sprintf "Your %s is fighting %s!!!" player_pokemon.base.name (Pokemon.name opponent));
  List.iteri
    (fun i (move: Pokemon.move) ->
      let label_text = Printf.sprintf "%d. %s (Type: %s, Damage: %d)\n" (i + 1) move.name
        (Pokemon.ptype_to_string move.m_ptype)
        move.damage in
      let button = GButton.button ~label:label_text ~packing:dialog#vbox#add () in
      ignore (
        button#connect#clicked ~callback:(fun () ->
          on_move_chosen (Some move) player_pokemon opponent (update_ui_string dialog) (update_ui_moves dialog moves player_pokemon opponent result) result;
        )
      );
    ) 
    moves; 
    let button = GButton.button ~label:"Switch Pokemon" ~packing:dialog#vbox#add () in
    ignore (
      button#connect#clicked ~callback:(fun () ->
        swap_team dialog update_ui_moves opponent result;
      ));
  dialog#show ();
)


let create_button label vbox callback =
  let button = GButton.button ~label ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback);
  button

let rec display_menu () =
  let window = GWindow.window ~width:900 ~height:400 ~title:"Main Menu" () in
  let vbox = GPack.vbox ~packing:window#add () in

  ignore (create_button "View Player Stats" vbox (fun () -> player_stats ()));
  
  if List.length !player.team = 0 then (
    ignore (create_button "Choose Your Starter!!!" vbox (fun () -> choose_starter ())); 
    ignore (create_button "Quit" vbox (fun () -> window# destroy(); GMain.Main.quit ()));
    window#show ();
    main_menu := Some window; 

    GMain.Main.main ())
else if List.length !player.team != 0 then(
    ignore (create_button "BATTLE: Wild Pokemon" vbox (fun () ->  wild_battle()));
    ignore (create_button "BATTLE: Trainer" vbox (fun () ->  trainer_battle()));
    ignore (create_button "BATTLE: Elite Four" vbox (fun () ->  elite_four_battle()));
    ignore (create_button "Pokemon Center" vbox (fun () ->  pokemon_center()));
    ignore (create_button "Quit" vbox (fun () -> window# destroy(); GMain.Main.quit ()));
    window#show ();
    main_menu := Some window; 

    GMain.Main.main () )

and pokemon_center () =
  if List.length !player.team = 0 then (
    raise_error_ui (get_main_menu()) "Obtain a pokemon first!";
  )
  else
    let dialog = GWindow.dialog
      ~title:"Poke Center"
      ~parent:(get_main_menu()) 
      ~width:500
      ~height:300
      ~destroy_with_parent:true
      ~modal:true
      () in

    (* Create a VBox for vertical arrangement of buttons *)
    let vbox = GPack.vbox ~spacing:10 ~packing:dialog#vbox#add () in

    (* Add buttons to the vbox *)
    let button_heal = GButton.button ~label:"Heal Pokemon (2 coins per pokemon)" ~packing:vbox#add () in
    ignore (button_heal#connect#clicked ~callback:(fun () -> on_heal dialog));

    let button_buy_legend = GButton.button ~label:"Purchase Legendary Pokemon (100 coins)" ~packing:vbox#add () in
    ignore (button_buy_legend#connect#clicked ~callback:(fun () -> on_buy_legend dialog));

    create_ok_button dialog ;

    dialog#show ();  

and on_heal dialog = 
  if List.length !player.team = 0 then raise_error_ui dialog "Choose a Pokemon First" else
  let healable_pokemon = List.filter (fun( p:Pokemon.pokemon) -> p.hp < p.current_max_hp) !player.team in
  let total_cost = 2 * List.length healable_pokemon in
  if total_cost > !player.coins then (
    message_ui dialog "Not enough coins!";
    pokemon_center ()
  ) else 
    List.iter (fun (pokemon: Pokemon.pokemon) ->
      if pokemon.hp < pokemon.current_max_hp then (
        pokemon.hp <- pokemon.current_max_hp;
        pokemon.feint <- false
      )
    ) !player.team;
    player := Player.adjust_coins (-total_cost) !player;
    message_ui dialog (sprintf "All Pokemon Healed! (%i coins used)" total_cost);

and on_buy_legend dialog = 
  if !player.coins < 50 then (
    raise_error_ui dialog "Not enough coins.\n";
    pokemon_center ()
  ) else (
    choose_pokemon dialog Pokedex.legendary_pokemon_base
    )

and choose_pokemon parent poke_list = (
  let rec take_n n lst acc =
    if n = 0 then
      acc
    else
      match lst with
      | [] -> acc
      | hd :: tl -> take_n (n - 1) tl (hd :: acc)
  in
  (* Shuffle the list to randomize the order *)
  let shuffled_pokemon_list = List.sort (fun _ _ -> if Random.bool () then 1 else -1) poke_list in

  (* Select the first three Pokémon from the shuffled list *)
  let chosen_pokemon_list = take_n 3 shuffled_pokemon_list [] in
  let dialog = GWindow.dialog
    ~title:"Choose Pokemon"
    ~parent:parent
    ~width:500
    ~height:300
    ~destroy_with_parent:true
    ~modal:true
    () in

  let add_legend chosen_pokemon = 
    let new_pokemon = Pokemon.create chosen_pokemon 30 in

    add_team new_pokemon dialog;
  in
  
  let options poke_list = (
    let vbox = GPack.vbox ~packing:dialog#vbox#add () in
    List.iter (fun (p:Pokemon.base_pokemon) ->
        let button = GButton.button
          ~label:(sprintf "%s" (p.name))
          ~packing:vbox#add () in
  
        ignore(button#connect#clicked ~callback:(fun _ -> dialog#destroy (); add_legend p; player := (Player.adjust_coins (-50) !player )));
      ) poke_list; 
      )
    in
  options chosen_pokemon_list;
  create_ok_button dialog;
  dialog#show ();
  )
and add_team new_pokemon par : unit =
  let team_size = List.length (Player.get_team !player) in
  print_endline "REACHED";
  print_endline (string_of_int team_size) ;
  if team_size < 6 then player :=
    {!player with team = new_pokemon :: !player.team};
    par# destroy ();
  if team_size >= 6 then
    begin
      print_endline "REACHED TEAM SIZE";
      let dialog = GWindow.dialog
        ~title:"Choose a Pokemon to Swap"
        ~parent: par
        ~width:500
        ~height:300
        ~destroy_with_parent:true
        ~modal:true
        () in
      let vbox = GPack.vbox ~packing:dialog#vbox#add () in

      List.iter (fun (p) ->
        let button = GButton.button
          ~label:(sprintf "%s" (Pokemon.name p))
          ~packing:vbox#add () in
        ignore(button#connect#clicked ~callback:(fun _ -> dialog#destroy (); swap_pokemon p new_pokemon;par# destroy ();));
      ) (Player.get_team !player); 
      dialog#show ();
    end
  
and swap_pokemon old new_pokemon = 
  let replaced_team = List.map (fun p -> if Pokemon.name p = Pokemon.name old then new_pokemon else p) (Player.get_team !player) in
  player := {!player with team = replaced_team };


and player_stats () = 
  let dialog = GWindow.dialog
  ~title:"Player Stats"
  ~parent:(get_main_menu()) 
  ~width:300
  ~height:200
  ~destroy_with_parent:true
  ~modal:true
  () in

  let label = GMisc.label ~text:(Player.player_to_string !player) () in
  ignore (dialog#vbox#add (label :> GObj.widget));

  let button = GButton.button ~label:"OK" ~packing:dialog#action_area#add () in
  ignore (button#connect#clicked ~callback:(fun () -> dialog#destroy ()));

  dialog#show ();

and elite_four_battle () =
  let elite_four_members : Trainer.trainer list = Array.to_list (Trainer.create_elite_four ()) in
  match elite_four_members with
  | [] -> ()
  | member :: rest ->
      trainer_battle_e4 member rest;

and trainer_battle_e4 (trainer: Trainer.trainer) rest= 
  let dialog = GWindow.dialog
  ~title: (sprintf "Battle with %s!!" trainer.name)
  ~parent:(get_main_menu()) 
  ~width:700
  ~height:600
  ~destroy_with_parent:true
  ~modal:true
  () in
  let opponent = trainer.current_pokemon in

  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in

  let available_pokemon = List.filter (fun (p: Pokemon.pokemon) -> not p.feint) (Player.get_team !player) in
  if List.length available_pokemon = 0 then raise_error_ui dialog "All Your Pokemon are Feinted" else

  dialog# show ();

  update_ui_moves dialog player_pokemon.base.moves player_pokemon opponent (on_trainer_result dialog player_pokemon trainer (Some rest));

and trainer_battle () = 
  let regular_trainers = Trainer.create_regular_trainers () in

  (* Randomly select a trainer from regular_trainers *)
  let trainer_index = Random.int (Array.length regular_trainers) in
  let trainer = regular_trainers.(trainer_index) in
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  let opponent = trainer.current_pokemon in

  let dialog = GWindow.dialog
  ~title: (sprintf "Battle with %s!!" trainer.name)
  ~parent:(get_main_menu()) 
  ~width:700
  ~height:600
  ~destroy_with_parent:true
  ~modal:true
  () in
  
  let available_pokemon = List.filter (fun (p: Pokemon.pokemon) -> not p.feint) (Player.get_team !player) in
  if List.length available_pokemon = 0 then raise_error_ui dialog "All Your Pokemon are Feinted" else

  dialog# show ();

  update_ui_moves dialog player_pokemon.base.moves player_pokemon opponent (on_trainer_result dialog player_pokemon trainer None) 

and on_trainer_result dialog player_pokemon trainer (rest) won = 
  if won then (
    update_ui_string dialog (sprintf "You defeated trainer %s's %s!\n"(trainer.name) (Pokemon.name trainer.current_pokemon));
    let remaining_opponents = List.filter (fun (p:Pokemon.pokemon) -> not p.feint) trainer.team in
    begin
    match remaining_opponents with
    | [] ->
        update_ui_string dialog (sprintf "You have defeated all of Trainer %s's Pokemon!\n" trainer.name);
        create_ok_button dialog;
        player := Player.adjust_coins 50 !player;
        update_ui_string dialog (sprintf"You earned 50 coins. Total coins: %d\n" !player.coins);
    
        let xp_gained = Pokemon.calculate_xp_gained trainer.current_pokemon.level in
        player := {
          !player with
          team = List.map (fun pkmn -> Pokemon.add_xp pkmn xp_gained) !player.team
        };
        update_ui_string dialog (sprintf "All your team Pokémon gained %d XP.\n" xp_gained);
        begin
        match rest with 
        | Some (h :: t) -> print_endline "NEXT TRAINER"; trainer_battle_e4 h t
        | Some [] -> dialog# destroy() ; beat_elite_four ()
        | None -> failwith "Unimplemented"
        end
    | new_opponent :: next_mon ->
        let updated_trainer = Battle.update_trainer_team trainer next_mon in
        update_ui_string dialog (sprintf "Trainer %s sends out %s!\n" trainer.name new_opponent.base.name);
        begin
        match rest with 
        | Some trainers ->
        update_ui_moves dialog player_pokemon.base.moves player_pokemon new_opponent (on_trainer_result dialog player_pokemon updated_trainer (Some trainers)); 
        | None -> update_ui_moves dialog player_pokemon.base.moves player_pokemon new_opponent (on_trainer_result dialog player_pokemon updated_trainer (None)) end end )
    else handle_feint_trainer dialog trainer
and beat_elite_four () = 
  let dialog = GWindow.dialog
  ~title: (sprintf "CONGRATS! You beat the elite four")
  ~parent:(get_main_menu()) 
  ~width:700
  ~height:600
  ~destroy_with_parent:true
  ~modal:true
  () in
  let label = GMisc.label ~text:("CONGRATS! You beat the elite four") () in
  ignore (dialog#vbox#add (label :> GObj.widget));
  dialog#show ();


and handle_feint_trainer dialog trainer = 
  let available_pokemon = List.filter (fun (p: Pokemon.pokemon) -> not p.feint) (Player.get_team !player) in
  if List.length available_pokemon = 0 then (
    update_ui_string dialog "All Pokemon have feinted. You lost the battle";
    create_ok_button dialog; )
  else (
    clear_container dialog#vbox;
    choose_new_pokemon_trainer dialog available_pokemon trainer;
    )

and choose_new_pokemon_trainer par available_pokemon trainer= 
  let dialog = GWindow.dialog
    ~title:"Choose Pokemon to send in Battle"
    ~parent:par  (* Access the main_menu reference *)
    ~width:300
    ~height:200
    ~destroy_with_parent:true
    ~modal:true
  () in
  List.iteri
  (fun index (pokemon) ->
    let button_label = Printf.sprintf "%d. %s" (index + 1) (Pokemon.name pokemon) in
    ignore (create_button button_label (dialog#vbox) (fun _ -> on_choose_new_trainer pokemon par trainer; dialog#destroy ()));
  )
  available_pokemon;
  dialog#show ();

and on_choose_new_trainer pokemon dialog trainer: unit= 
  player := {!player with current_pokemon = Some pokemon};
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  update_ui_moves dialog player_pokemon.base.moves player_pokemon trainer.current_pokemon (on_trainer_result dialog player_pokemon trainer None); 
    
and wild_battle () = 

  let opponent_index = Random.int (List.length Pokedex.wild_pokemon_base) in
  let opponent = Pokemon.create_random (List.nth Pokedex.wild_pokemon_base opponent_index) 5 in
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  let dialog = GWindow.dialog
  ~title: (sprintf "Wild Battle with %s!!" opponent.base.name)
  ~parent:(get_main_menu()) 
  ~width:700
  ~height:600
  ~destroy_with_parent:true
  ~modal:true
  () in
  let available_pokemon = List.filter (fun (p: Pokemon.pokemon) -> not p.feint) (Player.get_team !player) in
  if List.length available_pokemon = 0 then raise_error_ui dialog "All Your Pokemon are Feinted" else

  let label = GMisc.label ~text:(Printf.sprintf "A wild %s appears!" opponent.base.name) () in
  ignore (dialog#vbox#add (label :> GObj.widget));

  dialog#show ();

  update_ui_moves dialog player_pokemon.base.moves player_pokemon opponent (on_wild_result dialog player_pokemon opponent) ;


and on_wild_result dialog player_pokemon opponent won = 
  if won then (
    clear_container dialog#vbox;
    let reward =
      let min_reward = 1 in
      let max_reward = 5 in
      let earned_coins = min_reward + Random.int (max_reward - min_reward + 1) in
      earned_coins
    in
    player := Player.adjust_coins reward !player;
    update_ui_string dialog (sprintf "You defeated the wild %s!\n"(Pokemon.name opponent));
    update_ui_string dialog (sprintf "You won %d coins!\n" reward);
    let xp_gained = Pokemon.calculate_xp_gained opponent.level in
    let updated_pokemon = Pokemon.add_xp player_pokemon xp_gained in
    update_ui_string dialog (sprintf "Your %s gained %d XP.\n" updated_pokemon.base.name xp_gained);

    (* TODO: ADD LEVEL UP AND EVOLUTION *)
    player := Player.update_pokemon updated_pokemon !player;

    update_ui_string dialog (sprintf "Add %s to team?" (Pokemon.name opponent));

    let button = GButton.button ~label:"Yes" ~packing:dialog#vbox#add () in
    ignore (button#connect#clicked ~callback:(fun () -> ignore(add_team (Pokemon.copy_pokemon opponent) dialog);));
    let button = GButton.button ~label:"No" ~packing:dialog#vbox#add () in
    ignore (button#connect#clicked ~callback:(fun () -> ignore(dialog#destroy ();));
    )
  )
  else handle_feint_wild dialog opponent
and handle_feint_wild dialog opponent= 
  let available_pokemon = List.filter (fun (p: Pokemon.pokemon) -> not p.feint) (Player.get_team !player) in
    if List.length available_pokemon = 0 then (
      update_ui_string dialog "All Pokemon have feinted. You lost the battle";
      create_ok_button dialog; )
    else (
      clear_container dialog#vbox;
      choose_new_pokemon dialog available_pokemon opponent;
      )

and choose_new_pokemon par available_pokemon opponent= 
  let dialog = GWindow.dialog
    ~title:"Choose Pokemon to send in Battle"
    ~parent:par  (* Access the main_menu reference *)
    ~width:300
    ~height:200
    ~destroy_with_parent:true
    ~modal:true
  () in
  List.iteri
  (fun index (pokemon) ->
    let button_label = Printf.sprintf "%d. %s" (index + 1) (Pokemon.name pokemon) in
    ignore (create_button button_label (dialog#vbox) (fun _ -> on_choose_new pokemon par opponent; dialog#destroy ()));
  )
  available_pokemon;
  dialog#show ();

and on_choose_new pokemon dialog opponent: unit= 
  player := {!player with current_pokemon = Some pokemon};
  let player_pokemon =
    match !player.current_pokemon with
    | Some p -> p
    | None -> failwith "No current Pokémon to battle with"
  in
  update_ui_moves dialog player_pokemon.base.moves player_pokemon opponent (on_wild_result dialog player_pokemon opponent); 

and choose_starter () =
  let dialog = GWindow.dialog
    ~title:"Choose your starter pokemon"
    ~parent:(get_main_menu ())  (* Access the main_menu reference *)
    ~width:300
    ~height:200
    ~destroy_with_parent:true
    ~modal:true
    () in

  List.iteri
    (fun index (base_pokemon : Pokemon.base_pokemon) ->
      let button_label = Printf.sprintf "%d. %s" (index + 1) base_pokemon.name in
      ignore (create_button button_label (dialog#vbox) (fun () -> on_starter_selected base_pokemon));
    )
    starters_base;

  dialog#show ();

and on_starter_selected base_pokemon =
  let starter_pokemon = Pokemon.create base_pokemon 5 in
  let new_player, _ = Player.add_team starter_pokemon !player in
  player := new_player;
  print_endline (Player.player_to_string !player);
  
  (* Destroy the existing main menu window *)
  match !main_menu with
  | Some window ->
      window#destroy ();
      main_menu := None;  (* Reset the main_menu reference to None *)
      (* Redisplay the main menu to update with the chosen starter *)
      display_menu ()
  | None -> ()

let () =
  (* Initialize GTK *)
  ignore (GMain.Main.init ());

  (* Start the application *)
  display_menu ()