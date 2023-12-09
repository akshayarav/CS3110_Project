open Mylib

let player = ref Player.new_player
let starters_base = Pokedex.starters_base

let create_button label vbox callback =
  let button = GButton.button ~label ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback);
  button

let rec display_menu () =
  let window = GWindow.window ~width:500 ~height:400 ~title:"Main Menu" () in
  let vbox = GPack.vbox ~packing:window#add () in

  ignore (create_button "View Player Stats" vbox (fun () -> player_stats()));

  if List.length !player.team = 0 then 
    ignore (create_button "Choose your starter pokemon" vbox (fun () -> choose_starter()));
  if List.length !player.team > 0 then 
    ignore (create_button "Battle wild pokemon" vbox (fun () -> wild_battle()));

  ignore (window#connect#destroy ~callback:GMain.Main.quit);
  window#show ();

  (* Start the GTK main loop *)
  GMain.Main.main ()
and player_stats () = 
  let dialog = GWindow.dialog
    ~title:"Player Stats"
    ~parent:(GWindow.dialog ())
    ~width:300
    ~height:200
    ~destroy_with_parent:true
    ~modal:true  (* Set modal to true *)
    () in

  let label = GMisc.label ~text:(Player.player_to_string !player) () in
  ignore (dialog#vbox#add (label :> GObj.widget));

  let button = GButton.button ~label:"OK" ~packing:dialog#action_area#add () in
  ignore (button#connect#clicked ~callback:(fun () -> dialog#destroy ()));

  dialog#show ()

and wild_battle () = 
  let dialog = GWindow.dialog
    ~title:"Wild Pokemon Battle"
    ~parent:(GWindow.dialog ())
    ~width:300
    ~height:200
    ~destroy_with_parent:true
    ~modal:true  (* Set modal to true *)
    () in

  let opponent_index = Random.int (List.length Pokedex.wild_pokemon_base) in
  let base_opponent = List.nth Pokedex.wild_pokemon_base opponent_index in
  let opponent = Pokemon.create_random base_opponent 5 in

  (* Create a label to display battle message *)
  let label = GMisc.label ~text:(Printf.sprintf "A wild %s appears!" opponent.base.name) () in
  ignore (dialog#vbox#add (label :> GObj.widget));

  (* Add a button to close the dialog *)
  let button = GButton.button ~label:"OK" ~packing:dialog#action_area#add () in
  ignore (button#connect#clicked ~callback:(fun () -> dialog#destroy ()));

  dialog#show ()

and choose_starter () =
  let dialog = GWindow.dialog
    ~title:"Choose your starter pokemon"
    ~parent:(GWindow.dialog ())
    ~width:300
    ~height:200
    ~destroy_with_parent:true
    ~modal:true  (* Set modal to true *)
    () in

  List.iteri
    (fun index (base_pokemon : Pokemon.base_pokemon) ->
      let button_label = Printf.sprintf "%d. %s" (index + 1) base_pokemon.name in
      ignore (create_button button_label (dialog#vbox) (fun () -> on_starter_selected base_pokemon));
    )
    starters_base;

  dialog#show ()

and on_starter_selected base_pokemon =
  let starter_pokemon = Pokemon.create base_pokemon 5 in
  let new_player, _ = Player.add_team starter_pokemon !player in
  player := new_player;
  print_endline (Player.player_to_string !player);
  display_menu ()

let () =
  (* Initialize GTK *)
  ignore (GMain.Main.init ());

  (* Start the application *)
  display_menu ()
