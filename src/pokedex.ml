open Pokemon
open Moves

let bulbasaur = create "Bulbasaur" Grass 45 [ tackle; growl ] 5
let charmander = create "Charmander" Fire 39 [ scratch; growl ] 5
let squirtle = create "Squirtle" Water 44 [ tackle; tail_whip ] 5
let starters = [ bulbasaur; charmander; squirtle ]
let pidgey = create "Pidgey" Normal 100 [] 1
let wild_pokemon = [ pidgey ]
