open Moves

let base_bulbasaur =
  {
    name = "Bulbasaur";
    ptype = Grass;
    max_hp = 45;
    moves = [ tackle; growl; leech_seed; vine_whip ];
  }

let base_charmander =
  {
    name = "Charmander";
    ptype = Fire;
    max_hp = 39;
    moves = [ scratch; growl; ember ];
  }

let base_squirtle =
  {
    name = "Squirtle";
    ptype = Water;
    max_hp = 44;
    moves = [ tackle; tail_whip; water_gun ];
  }

let base_pidgey =
  {
    name = "Pidgey";
    ptype = Normal;
    max_hp = 31;
    moves = [ quick_attack; gust ];
  }

let base_rattata =
  {
    name = "Rattata";
    ptype = Normal;
    max_hp = 31;
    moves = [ tackle; quick_attack ];
  }

let base_spearow =
  { name = "Spearow"; ptype = Normal; max_hp = 31; moves = [ peck ] }

let starters_base = [ base_bulbasaur; base_charmander; base_squirtle ]
let wild_pokemon_base = [ base_pidgey; base_rattata; base_spearow ]
