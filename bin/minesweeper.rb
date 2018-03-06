require './lib/minesweeper'
# MinesWeeper.new.continous_play
config = { dimension: [8, 8], separator: ' ', mines: 4 }
MinesWeeper.new(config: config).continous_play
