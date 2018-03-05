require 'spec_helper'
require 'minesweeper'

describe 'general' do
  before do
    @game = MinesWeeper.new
  end
  it 'initialized game' do
    board = @game.gen_board([4, 4], [[0, 0], [2, 1]])
    expect(board[0][0]).to eq('*')
    expect(board[1][1]).to eq('.')
    expect(board[2][1]).to eq('*')
    expect(board[3][3]).to eq('.')
  end
  
  # it 'checks' do
  #   game1 = MinesWeeper.new
  #   show(game1)
  # 
  #   config = { dimension: [8, 4], num_mines: 40 }
  #   game1 = MinesWeeper.new(config: config)
  #   show(game1)
  #   game1.new_game
  #   show(game1)
  # end
  
  it 'test case' do
    # result = @game.read_dimensions do
    #   res = ''
    #   filename = './spec/mastermind/minesweeper_testcase1_in.txt'
    #   File.open(filename).each_line do |line|
    #     res += line.chomp.strip + "\n"
    #   end
    #   res
    # end
    # puts "RESULT:#{result}"
  end
end

def show(game1)
  puts "GAME (#{game1.config})"
  puts 'GameBoard:'
  game1.show_game_board
  puts 'Solution:'
  game1.show_solution
  puts '---------'
end
