MINE = '*'.freeze
FIELD = '.'.freeze
DEF_SEPARATOR = ''.freeze
DEF_DIMENSION = [4, 4].freeze
DEF_MINES = 3

# Class MinesWeeper
class MinesWeeper
  attr_accessor :config, :game_board, :solution, :player_board

  # Initialize class: define configuration, the new game board
  # and the solution to the generated game_board
  def initialize(attributes = {})
    initialize_config(attributes[:config])
    @game_board = attributes[:game_board]
    @solution = attributes[:solution]
  end

  # Initialize config with default values if needed
  def initialize_config(config)
    @config = config
    @config ||= { dimension: DEF_DIMENSION, mines: DEF_MINES,
                  separator: DEF_SEPARATOR }
    @config[:dimension] ||= DEF_DIMENSION
    @config[:mines] ||= DEF_MINES
    @config[:separator] ||= DEF_SEPARATOR
  end

  # Suggested Test Cases
  def test_case
    result = ''
    field = 1
    while (line = gets.chomp.strip)
      return result if line == '0 0'
      next unless (dim_line = read_numbers(line))
      result += read_board_line(dim_line[0], dim_line[1], field)
      field += 1
    end
  end

  # Read a pair of numbers. Ex: 4 4
  def read_numbers(line)
    dim_line = /^(\d{1}) (\d{1})$/.match line
    return nil unless dim_line
    [dim_line[1].to_i, dim_line[2].to_i]
  end

  # Read a board line. Ex .*..
  def read_board_line(rows, cols, field)
    board = gen_board([rows, cols])
    num_row = 0
    while (line = gets.chomp.strip)
      next unless line.length >= cols
      board[num_row] = line.scan(/\W/)
      num_row += 1
      next unless num_row >= rows
      return "Field \##{field}\n#{show_board(gen_solution(board))}"
    end
  end

  # Generate a new game board
  def gen_board(dimensions, mines = nil)
    board = Array.new(dimensions[0]) { Array.new(dimensions[1], FIELD) }
    mines ||= gen_mines(dimensions)
    mines.each { |x, y| board[x][y] = MINE }
    board
  end

  # Generate the position of n random mines (@config[:mines])
  # (relative to the dimension param)
  def gen_mines(dimension)
    mines = []
    @config[:mines].times do
      mines.push([Random.rand(dimension[0]), Random.rand(dimension[1])])
    end
    mines
  end

  # Generate the solution board
  def gen_solution(game_board)
    solution = gen_board([game_board.length, game_board[0].length])
    solution.each_with_index do |x, col|
      x.each_with_index do |_y, row|
        solution[col][row] = num_mines(game_board, col, row).to_s
      end
    end
    solution
  end

  # Relative positions around a position (x, y)
  def positions(x, y)
    [
      [x - 1, y - 1], [x - 1, y], [x - 1, y + 1],
      [x, y - 1], [x, y + 1],
      [x + 1, y - 1], [x + 1, y], [x + 1, y + 1]
    ]
  end

  # Return the number of mines in the board around the current position (x, y)
  def num_mines(board, x, y)
    return MINE if check_mine?(board[x][y])
    num = 0
    positions(x, y).map do |x1, y1|
      next unless board[x1] && x1 >= 0 && y1 >= 0
      num += 1 if check_mine?(board[x1][y1])
    end
    num.to_s
  end

  # Check if the cell is a mine
  def check_mine?(cell)
    return false unless cell
    return false unless cell == MINE
    true
  end

  # Show the game board
  def show_game_board
    puts show_board(@game_board)
  end

  # Show the solution board
  def show_solution
    puts show_board(@solution)
  end

  # Show the player board
  def show_player_board
    puts show_board(@player_board)
  end

  # Show a board
  def show_board(board)
    return unless board
    result = ''
    board.each do |i|
      result += @config[:separator] + i.join(@config[:separator]) + "\n"
    end
    result += "\n"
  end

  # Welcome message
  def welcome
    system 'clear'
    puts 'MinesWeeper'
    puts
  end

  # Initialize a new game
  def new_game
    welcome
    @game_board = gen_board(@config[:dimension])
    @solution = gen_solution(@game_board)
    @player_board = gen_board(@config[:dimension], [])
    show_player_board
  end

  # Play again mode
  def continous_play
    loop do
      play
      puts
      print 'Do you want to play again? (y/n) '
      break unless gets.chomp.strip == 'y'
    end
  end

  # Play a game
  def play
    new_game
    while (line = gets.chomp.strip)
      return false if line == 'q'
      mine_found = turn?(line)
      return true if end_game?(mine_found)
    end
  end

  # Play a turn
  def turn?(line)
    pos = read_numbers(line)
    puts 'Wrong combination. Ex: 1 1' unless pos
    return true unless pos && @player_board[pos[0]]
    cell = @solution[pos[0]][pos[1]]
    @player_board[pos[0]][pos[1]] = cell
    show_zeros(pos[0], pos[1]) if cell == '0'
    turn_message(check_mine?(cell), line)
  end

  # Play a turn message
  def turn_message(mine_found, line)
    welcome
    show_player_board
    puts line
    puts mine_found ? ' ... BOOM!' : 'Well done! Dig again ...'
    mine_found
  end

  # Check the end of the game
  def end_game?(mine_found)
    mines = 0
    @solution.each { |x| x.each { |y| mines += 1 if y == MINE } }
    dots = 0
    @player_board.each { |x| x.each { |y| dots += 1 if y == FIELD } }
    return true if dots <= mines && win
    return false unless mine_found
    puts 'You lose!!'
    true
  end

  # User has win
  def win
    welcome
    show_solution
    puts 'You win!!'
    true
  end

  # Show all zeros around the checked position (x, y)
  def show_zeros(x, y)
    positions(x, y).map do |x1, y1|
      next unless @solution[x1] && x1 >= 0 && y1 >= 0
      if @solution[x1][y1] == '0' && @player_board[x1][y1] == FIELD
        @player_board[x1][y1] = @solution[x1][y1]
        show_zeros(x1, y1)
      elsif @solution[x1][y1] != MINE && @player_board[x1][y1] == FIELD
        @player_board[x1][y1] = @solution[x1][y1]
      end
    end
  end
end
