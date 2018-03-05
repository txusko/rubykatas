MINE = '*'.freeze
FIELD = '.'.freeze
DEF_SEPARATOR = ''.freeze
DEF_DIMENSION = [8, 8].freeze
DEF_MINES = 10

# Class MinesWeeper
class MinesWeeper
  attr_accessor :config, :game_board, :solution, :player_board

  # Initialize class: define configuration, the new game board
  # and the solution to the generated game_board
  def initialize(attributes = {})
    initialize_config(attributes[:config])
    @game_board = attributes[:game_board]
    @solution = attributes[:solution]
    # new_game unless @game_board
  end

  def initialize_config(config)
    @config = config
    @config ||= { dimension: DEF_DIMENSION, mines: DEF_MINES,
                  separator: DEF_SEPARATOR }
    @config[:dimension] ||= DEF_DIMENSION
    @config[:mines] ||= DEF_MINES
    @config[:separator] ||= DEF_SEPARATOR
  end

  def start
    puts read_dimensions
  end

  def read_dimensions
    result = ''
    field = 1
    while (line = gets.chomp.strip)
      return result if line == '0 0'
      next unless (dim_line = read_line_dim(line))
      result += "Field \##{field}\n"
      result += read_board_lines(dim_line[0], dim_line[1])
      field += 1
    end
  end

  def read_line_dim(line)
    dim_line = /^(\d{1}) (\d{1})$/.match line
    return nil unless dim_line
    [dim_line[1].to_i, dim_line[2].to_i]
  end

  def read_board_lines(rows, cols)
    board = gen_board([rows, cols])
    num_row = 0
    while (line = gets.chomp.strip)
      next unless line.length >= cols
      board[num_row] = line.scan(/\W/)
      num_row += 1
      return show_board(gen_solution(board)) if num_row >= rows
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
  # relative to the dimension param
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

  # Relative positions around the current position (x, y)
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
    board.each { |i| result += ' ' + i.join(@config[:separator]) + "\n" }
    result += "\n"
  end

  def continous_play
    loop do
      play
      print 'Do you want to play again? (y/n) '
      break unless gets.chomp.strip == 'y'
    end
  end

  def play
    new_game
    mines = @game_board.select { |x| x.select { |y| y == MINE } }.length
    while (line = gets.chomp.strip)
      return false if line == 'q'
      ok = turn?(line)
      dots_left = 0
      @player_board.each { |x| x.each { |y| dots_left += 1 if y == FIELD } }
      if dots_left <= mines
        system 'clear'
        puts 'You win!!'
        show_solution
        return true
      end
      next if ok
      puts 'You lose!!'
      return false
    end
  end

  # Initialize a new game
  def new_game
    system 'clear'
    welcome
    @game_board = gen_board(@config[:dimension])
    @solution = gen_solution(@game_board)
    @player_board = gen_board(@config[:dimension], [])
    show_player_board
  end

  def welcome
    puts 'MinesWeeper'
    puts
  end

  def turn?(line)
    puts 'Wrong combination. Ex: 1 1' unless (pos = read_line_dim(line))
    return true unless pos && @player_board[pos[0]]
    @player_board[pos[0]][pos[1]] = @solution[pos[0]][pos[1]]
    ok = check_mine?(@solution[pos[0]][pos[1]])
    turn_message(ok, line)
    !ok
  end

  def turn_message(ok, line)
    system 'clear'
    welcome
    show_player_board
    puts line
    puts ok ? ' ... BOOM!' : 'Dig again!'
  end
end
