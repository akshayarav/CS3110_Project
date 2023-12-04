include Pokemon

let tackle = { name = "Tackle"; damage = 10; m_ptype = Normal }
let growl = { name = "Growl"; damage = 0; m_ptype = Normal }
let scratch = { name = "Scratch"; damage = 10; m_ptype = Normal }
let tail_whip = { name = "Tail Whip"; damage = 0; m_ptype = Normal }
let ember = { name = "Ember"; damage = 10; m_ptype = Fire }
let leech_seed = { name = "Leech Seed"; damage = 5; m_ptype = Grass }
let vine_whip = { name = "Vine Whip"; damage = 10; m_ptype = Grass }
let water_gun = { name = "Water Gun"; damage = 10; m_ptype = Water }
let bubble = { name = "Bubble"; damage = 10; m_ptype = Water }
let quick_attack = { name = "Quick Attack"; damage = 10; m_ptype = Normal }
let gust = { name = "Gust"; damage = 10; m_ptype = Flying }
let peck = { name = "Peck"; damage = 10; m_ptype = Flying }
let razor_leaf = { name = "Razor Leaf"; damage = 15; m_ptype = Grass }
let solar_beam = { name = "Solar Beam"; damage = 20; m_ptype = Grass }
let flamethrower = { name = "Flamethrower"; damage = 15; m_ptype = Fire }
let fire_blast = { name = "Fire Blast"; damage = 20; m_ptype = Fire }
let water_pulse = { name = "Water Pulse"; damage = 15; m_ptype = Water }
let hydro_pump = { name = "Hydro Pump"; damage = 20; m_ptype = Water }
let wing_attack = { name = "Wing Attack"; damage = 15; m_ptype = Flying }
let hurricane = { name = "Hurricane"; damage = 20; m_ptype = Flying }
let hyper_fang = { name = "Hyper Fang"; damage = 15; m_ptype = Normal }
let drill_peck = { name = "Drill Peck"; damage = 20; m_ptype = Flying }
let thunder_shock = { name = "Thunder Shock"; damage = 10; m_ptype = Electric }
let thunder_wave = { name = "Thunder Wave"; damage = 0; m_ptype = Electric }
let electro_ball = { name = "Electro Ball"; damage = 15; m_ptype = Electric }
let thunder = { name = "Thunder"; damage = 20; m_ptype = Electric }
let sing = { name = "Sing"; damage = 0; m_ptype = Normal }
let pound = { name = "Pound"; damage = 10; m_ptype = Normal }
let double_slap = { name = "Double Slap"; damage = 15; m_ptype = Normal }
let rest = { name = "Rest"; damage = 0; m_ptype = Normal }
let hyper_voice = { name = "Hyper Voice"; damage = 20; m_ptype = Normal }
let confusion = { name = "Confusion"; damage = 10; m_ptype = Psychic }
let fury_swipes = { name = "Fury Swipes"; damage = 15; m_ptype = Normal }
let disable = { name = "Disable"; damage = 10; m_ptype = Normal }
let sand_attack = { name = "Sand Attack"; damage = 0; m_ptype = Ground }
let bulldoze = { name = "Bulldoze"; damage = 15; m_ptype = Ground }
let dig = { name = "Dig"; damage = 40; m_ptype = Ground }
let hyper_beam = { name = "Hyper Beam"; damage = 25; m_ptype = Normal }
let future_sight = { name = "Future Sight"; damage = 20; m_ptype = Psychic }
let extreme_speed = { name = "Extreme Speed"; damage = 20; m_ptype = Normal }
let sleep_powder = { name = "Sleep Powder"; damage = 0; m_ptype = Grass }
let poison_powder = { name = "Poison Powder"; damage = 0; m_ptype = Grass }
let thunder_punch = { name = "Thunder Punch"; damage = 15; m_ptype = Electric }
let ice_punch = { name = "Ice Punch"; damage = 15; m_ptype = Ice }
let fire_punch = { name = "Fire Punch"; damage = 15; m_ptype = Fire }
let earthquake = { name = "Earthquake"; damage = 20; m_ptype = Ground }
let psychic = { name = "Psychic"; damage = 15; m_ptype = Psychic }
let shadow_ball = { name = "Shadow Ball"; damage = 15; m_ptype = Ghost }
let dragon_claw = { name = "Dragon Claw"; damage = 15; m_ptype = Dragon }
let ice_beam = { name = "Ice Beam"; damage = 15; m_ptype = Ice }
let blizzard = { name = "Blizzard"; damage = 20; m_ptype = Ice }
let bite = { name = "Bite"; damage = 15; m_ptype = Dark }
let dragon_rage = { name = "Dragon Rage"; damage = 40; m_ptype = Dragon }
let leer = { name = "Leer"; damage = 0; m_ptype = Normal }
let slam = { name = "Slam"; damage = 20; m_ptype = Normal }
let psybeam = { name = "Psybeam"; damage = 15; m_ptype = Psychic }
let reflect = { name = "Reflect"; damage = 0; m_ptype = Psychic }
let recover = { name = "Recover"; damage = 0; m_ptype = Normal }
let roar = { name = "Roar"; damage = 0; m_ptype = Normal }
let take_down = { name = "Take Down"; damage = 25; m_ptype = Normal }
let all_moves =
  [
    tackle;
    growl;
    scratch;
    tail_whip;
    ember;
    leech_seed;
    vine_whip;
    water_gun;
    bubble;
    quick_attack;
    gust;
    peck;
    razor_leaf;
    solar_beam;
    flamethrower;
    fire_blast;
    water_pulse;
    hydro_pump;
    wing_attack;
    hurricane;
    hyper_fang;
    drill_peck;
    thunder_shock;
    thunder_wave;
    electro_ball;
    thunder;
    sing;
    pound;
    double_slap;
    rest;
    hyper_voice;
    confusion;
    fury_swipes;
    sand_attack;
    bulldoze;
    dig;
    sleep_powder;
    poison_powder;
    thunder_punch;
    ice_punch;
    fire_punch;
    earthquake;
    psychic;
    shadow_ball;
    dragon_claw;
    ice_beam;
    blizzard;
    hyper_beam;
    bite;
    dragon_rage;
    leer;
    slam;
    psybeam;
    recover;
    roar;
    take_down;
  ]