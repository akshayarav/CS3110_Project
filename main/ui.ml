open Mylib

let player = ref Player.new_player
let starters_base = Pokedex.starters_base

let create_button label vbox callback =
  let button = GButton.button ~label ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback);
  button

let rec display_menu () =
  let window = GWindow.window ~width:300 ~height:250 ~title:"Main Menu" () in
  let vbox = GPack.vbox ~packing:window#add () in

  ignore (create_button "Choose your starter pokemon" vbox (fun () -> choose_starter ()));
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  window#show ();

  (* Start the GTK main loop *)
  GMain.Main.main ()


and choose_starter () =
  let dialog = GWindow.dialog
    ~title:"Choose your starter pokemon"
    ~parent:(GWindow.dialog ())
    ~width:300
    ~height:200
    ~destroy_with_parent:true
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
  (* printf "You chose %s!\n" starter_pokemon.base.name; *)
  print_endline (Player.player_to_string !player);
  display_menu ()


let () =
  (* Initialize GTK *)
  ignore (GMain.Main.init ());

  (* Start the application *)
  display_menu ()
