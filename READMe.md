ocaml_pokemon/
│
├── _build/             # Compiled files
│
├── src/                # Source files
│   ├── main.ml         # Entry point of the game
│   ├── pokemon.ml      # Defines Pokémon structures and basic functionality
│   ├── move.ml         # Defines moves that Pokémon can use
│   ├── battle.ml       # Battle mechanics, turn resolution, win/loss detection
│   ├── player.ml       # Defines player & computer AI behavior
│   ├── ai_random.ml    # Random AI strategy
│   ├── ai_greedy.ml    # Greedy AI strategy
│   ├── ai_typematch.ml # Type-Matchup AI strategy
│   ├── ai_predict.ml   # Predictive AI strategy
│   ├── ai_statbased.ml # Stat-Based AI strategy
│   └── ai_utility.ml   # Utility AI strategy
│
├── data/               # Database of Pokémon, moves, etc.
│   ├── pokemon_data.ml
│   └── move_data.ml
│
└── Makefile            # For compiling & building the project