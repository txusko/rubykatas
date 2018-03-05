require './lib/minesweeper'
config = { dimension: [8, 8], separator: ' ', mines: 10 }
MinesWeeper.new(config: config).continous_play
