open Printf

let rec main () = 
  printf "Welcome to Pokemon Lite! This is a small game with inspiration from the Pokemon franchise, with the goal to beat the Elite Four\n";
  printf "Please choose to play the game in the GUI or Text-Based in the terminal\n";
  printf "1: GUI\n";
  printf "2: Text-Based\n";
  printf "3: Exit\n";
  let choice = read_line () in 
  match choice with 
  | "1" -> ignore (Sys.command "make gui")
  | "2" -> ignore (Sys.command "make text-based")
  | "3" -> exit 0
  | _ -> printf "Invalid choice\n"; main ()

let () = main ()
