require 'spec_helper'
require 'minesweeper'

describe 'general' do
  before do
    @game = MinesWeeper.new
  end
  it 'initialized game' do
    board = @game.gen_board([4, 4], [[0, 0], [2, 1]])
    # length
    expect(board.length).to eq(4)
    expect(board[0].length).to eq(4)
    # mines
    expect(board[0][0]).to eq('*')
    expect(board[2][1]).to eq('*')
    # dots
    expect(board[1][1]).to eq('.')
    expect(board[3][3]).to eq('.')
  end

  it 'read numbers' do
    expect(@game.read_numbers('2 3')).to eq([2, 3])
    expect(@game.read_numbers('something')).to be_nil
    expect(@game.read_numbers('something more')).to be_nil
    expect(@game.read_numbers('1 more')).to be_nil
    expect(@game.read_numbers('something 1')).to be_nil
    expect(@game.read_numbers('3 2')).to_not eq([2, 3])
  end

  it 'read board lines 1' do
    board = ['*...', '....', '.*..', '....']
    result = @game.show_board(@game.gen_solution(board))
    res = "*100\n2210\n1*10\n1110\n\n"
    expect(result).to eq(res)
  end

  it 'read board lines 2' do
    board = ['**...', '.....', '.*...']
    result = @game.show_board(@game.gen_solution(board))
    res = "**100\n33200\n1*100\n\n"
    expect(result).to eq(res)
  end

  # it 'checks' do
  #   game1 = MinesWeeper.new
  #   show(game1)
  #   config = { dimension: [8, 4], num_mines: 40 }
  #   game1 = MinesWeeper.new(config: config)
  #   show(game1)
  #   game1.new_game
  #   show(game1)
  #   result = @game.read_dimensions do
  #     res = ''
  #     filename = './spec/minesweeper/minesweeper_testcase1_in.txt'
  #     File.open(filename).each_line do |line|
  #       res += line.chomp.strip + "\n"
  #     end
  #     res
  #   end
  #   puts "RESULT:#{result}"
  # end

end

def show(game1)
  puts "GAME (#{game1.config})"
  puts 'GameBoard:'
  game1.show_game_board
  puts 'Solution:'
  game1.show_solution
  puts '---------'
end
