open Pokemon
open Trainer

let update_trainer_team (trainer : trainer) (new_team : pokemon list) =
  { trainer with team = new_team }
