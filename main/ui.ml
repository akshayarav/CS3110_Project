open Mylib
open Printf

let main_menu : (GWindow.window option) ref = ref None

let get_main_menu () = 
  match !main_menu with 
  | Some (window) -> window
  | None -> failwith "No window"

let player = ref Player.new_player
let starters_base = Pokedex.starters_base

(** Callback to update the UI during battles *)
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
  

let rec update_ui_moves dialog moves player_pokemon opponent result = (
  clear_container dialog#vbox;
  List.iteri
    (fun i (move: Pokemon.move) ->
      let label_text = Printf.sprintf "%d. %s (Type: %s, Damage: %d)\n" (i + 1) move.name
        (Pokemon.ptype_to_string move.m_ptype)
        move.damage in
      let button = GButton.button ~label:label_text ~packing:dialog#vbox#add () in
      ignore (
        button#connect#clicked ~callback:(fun () ->
            Battle.on_move_chosen (Some move) player_pokemon opponent (update_ui_string dialog) (update_ui_moves dialog moves player_pokemon opponent result) result;
        )
      );
    ) 
    moves;  (* This is the list being iterated over *)
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
  
  if List.length !player.team = 0 then 
    ignore (create_button "Choose your starter pokemon" vbox (fun () -> choose_starter ()));
  if List.length !player.team > 0 then 
    ignore (create_button "Battle wild pokemon" vbox (fun () ->  wild_battle()));
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  window#show ();
  main_menu := Some window;  (* Update the main_menu reference *)

  (* Start the GTK main loop *)
  GMain.Main.main ()
and player_stats () = 
  let dialog = GWindow.dialog
  ~title:"Player Stats"
  ~parent:(get_main_menu())  (* Access the main_menu reference *)
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

  let label = GMisc.label ~text:(Printf.sprintf "A wild %s appears!" opponent.base.name) () in
  ignore (dialog#vbox#add (label :> GObj.widget));

  dialog#show ();

  update_ui_moves dialog player_pokemon.base.moves player_pokemon opponent (on_wild_result dialog player_pokemon opponent) ;


and on_wild_result dialog player_pokemon opponent won = 
  if won then (
    let reward =
      let min_reward = 1 in
      let max_reward = 5 in
      let earned_coins = min_reward + Random.int (max_reward - min_reward + 1) in
      earned_coins
    in
    player := Player.adjust_coins reward !player;
    update_ui_string dialog (sprintf "You also won %d coins!\n" reward);
    let xp_gained = Pokemon.calculate_xp_gained opponent.level in
    let updated_pokemon = Pokemon.add_xp player_pokemon xp_gained in
    update_ui_string dialog (sprintf "Your %s gained %d XP.\n" updated_pokemon.base.name xp_gained);

    (* TODO: ADD LEVEL UP AND EVOLUTION *)
    player := Player.update_pokemon updated_pokemon !player;
    create_ok_button dialog;
(* 
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
        printf "Invalid choice. Not adding %s to your team.\n" name *)
  );


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
