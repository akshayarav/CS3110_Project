open Moves

let create_random_hp_pokemon name ptype moves =
  create name ptype (10 + Random.int 51) moves 1

let bulbasaur =
  create "Bulbasaur" Grass 45 [ tackle; growl; leech_seed; vine_whip ] 5

let charmander = create "Charmander" Fire 39 [ scratch; growl; ember ] 5
let squirtle = create "Squirtle" Water 44 [ tackle; tail_whip; water_gun ] 5
let starters = [ bulbasaur; charmander; squirtle ]
let pidgey = create_random_hp_pokemon "Pidgey" Normal [ quick_attack; gust ]
let rattata = create_random_hp_pokemon "Rattata" Normal [ tackle; quick_attack ]
let spearow = create_random_hp_pokemon "Spearow" Normal [ peck ]
let wild_pokemon = [ pidgey; rattata; spearow ]
