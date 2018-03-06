require './lib/minesweeper'
# MinesWeeper.new.continous_play
config = { dimension: [7, 5], separator: ' ', mines: 8 }
MinesWeeper.new(config: config).continous_play
