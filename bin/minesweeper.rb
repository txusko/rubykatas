require './lib/minesweeper'
config = { dimension: [2, 2], separator: ' ', mines: 1 }
MinesWeeper.new(config: config).continous_play
