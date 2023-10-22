open Moves

let bulbasaur =
  create "Bulbasaur" Grass 45 [ tackle; growl; leech_seed; vine_whip ] 5

let charmander = create "Charmander" Fire 39 [ scratch; growl; ember ] 5
let squirtle = create "Squirtle" Water 44 [ tackle; tail_whip; water_gun ] 5
let starters = [ bulbasaur; charmander; squirtle ]
let pidgey = create "Pidgey" Normal 100 [ quick_attack; gust ] 1
let rattata = create "Rattata" Normal 100 [ tackle; quick_attack ] 1
let spearow = create "Spearow" Normal 100 [ peck ] 1
let wild_pokemon = [ pidgey; rattata; spearow ]
