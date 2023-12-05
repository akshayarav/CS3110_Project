open Pokemon

type trainer = {
  name : string;
  team : pokemon list;
  current_pokemon : pokemon option;
}

(* Function to create a new trainer *)
let create_trainer name team current_pokemon =
  { name; team ; current_pokemon}
