MINE = '*'.freeze
FIELD = '.'.freeze
MARK = '!'.freeze
DEF_SEPARATOR = ' '.freeze
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

  def read_line
    puts
    print 'Enter a combination: '
    gets.chomp.strip
  end

  # Suggested Test Cases
  def test_case
    result = ''
    field = 1
    while (line = read_line)
      return result if line == '0 0'
      next unless (dim_line = gets.chomp.strip)
      result += read_board_line(dim_line[0], dim_line[1], field)
      field += 1
    end
  end

  # Read a pair of numbers. Ex: 4 4
  def read_numbers(line)
    line = line[1, line.length] if line[0] == 'm'
    dim_line = /^(\d{1}) (\d{1})$/.match line.strip
    return nil unless dim_line
    [dim_line[1].to_i, dim_line[2].to_i]
  end

  def check_numbers?(pos)
    error = 0
    error = 1 unless pos
    message = ''
    if pos
      error = 2 if pos[0] < 0 || pos[1] < 0
      error = 3 if pos[1] >= @solution[0].length
      error = 4 if pos[0] >= @solution.length
      message += pos[0].to_s + ' ' + pos[1].to_s + ' - '
    end
    unless error.zero?
      message += error_message(error).red
      puts message
    end
    error.zero?
  end

  def error_message(error_number)
    case error_number
    when 1 then 'Wrong combination (row column) Examples: \'1 1\' or \'m 2 3\'.'
    when 2 then 'Wrong combination. Row and column numbers should be positive.'
    when 3 then 'Wrong combination. Row number outside the board limits.'
    when 4 then 'Wrong combination. Column number outside the board limits.'
    else 'Unexpected error'
    end
  end

  # Read a board line. Ex .*..
  def read_board_line(rows, cols, field)
    board = gen_board([rows, cols])
    num_row = 0
    while (line = read_line)
      next unless line.length >= cols
      board[num_row] = line.scan(/\W/)
      num_row += 1
      next unless num_row >= rows
      return "Field \##{field}\n#{show_board(gen_solution(board))}\n"
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

  # Relative positions around a position (row, col)
  def positions(row, col)
    [
      [row - 1, col - 1], [row - 1, col], [row - 1, col + 1],
      [row, col - 1], [row, col + 1],
      [row + 1, col - 1], [row + 1, col], [row + 1, col + 1]
    ]
  end

  # Return the number of mines in the board around the current position (x, y)
  def num_mines(board, row, col)
    return MINE if check_mine?(board[row][col])
    num = 0
    positions(row, col).map do |x, y|
      next unless board[x] && x >= 0 && y >= 0
      num += 1 if check_mine?(board[x][y])
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
    puts
  end

  # Show the solution board
  def show_solution
    puts show_player_board(@solution)
    puts
  end

  # Show the player board
  def show_player_board(board)
    return nil unless board && board[0]
    puts show_axis(board[0].length)
    puts show_line(board[0].length)
    puts show_board(board, true)
    puts show_line(board[0].length)
    puts " - Mines: #{number_of_mines}"
    puts " - Marked: #{number_of_marked_mines}"
    puts " - Dots: #{number_of_dots - number_of_mines}"
    puts
  end

  def show_axis(elements)
    return unless elements || elements > 0
    res = ' ' * 4
    (0...elements).each { |index| res += index.to_s + @config[:separator] }
    res += "\n"
  end

  def show_line(elements)
    res = ' ' * 3
    (0..elements).each { res += '--' }
    res[0, res.length - 1]
  end

  # Show a board
  def show_board(board, axis = false)
    return unless board
    result = ''
    board.each_with_index do |el, index|
      result += index.to_s + @config[:separator] + '| ' if axis
      result += el.join(@config[:separator])
      result += @config[:separator] + '|' if axis
      result += "\n"
    end
    result
  end

  # Welcome message
  def title
    system 'clear'
    puts
    title = ' ** MinesWeeper ** '
    puts title
    puts '-' * title.length
    puts
  end

  def welcome
    puts "There are #{number_of_mines} hidden mines in the game board. "
    puts "Enter combinations of numbers (Ex. 0 0) to show what's behind " \
         'each dot, but be careful to not hit on a mine.'
    puts 'Your mission is to discover all the dots without a mine behind.'
    puts 'Additional commands:'
    puts ' - Mark mines: m 0 0'
    puts ' - Quit game: q'
  end

  # Initialize a new game
  def new_game
    @game_board = gen_board(@config[:dimension])
    @solution = gen_solution(@game_board)
    @player_board = gen_board(@config[:dimension], [])
    title
    show_player_board(@player_board)
    welcome
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
    while (line = read_line)
      return false if line == 'q'
      pos = read_numbers(line)
      next unless check_numbers?(pos)
      mine_found = turn?(pos, line)
      return true if end_game?(mine_found)
    end
  end

  # Play a turn
  def turn?(pos, line)
    return false unless pos && @player_board[pos[0]]
    cell = @solution[pos[0]][pos[1]]
    mark_mine(pos[0], pos[1]) if line[0] == 'm'
    mine_found = if line[0] != 'm'
                   @player_board[pos[0]][pos[1]] = cell
                   show_zeros(pos[0], pos[1]) if cell == '0'
                   check_mine?(cell)
                 end
    turn_message(mine_found, line)
    mine_found
  end

  # Play a turn message
  def turn_message(mine_found, line)
    title
    show_player_board(@player_board)
    mes = line + ' - '
    mes += mine_found ? 'BOOM!!!'.red : 'Well done! Dig again ...'.green
    puts mes
  end

  # Check the end of the game
  def end_game?(mine_found)
    return true if number_of_dots <= number_of_mines && win
    return false unless mine_found
    puts 'You lose!!'
    true
  end

  def number_of_dots
    number_of_items(@player_board, FIELD) + number_of_marked_mines
  end

  def number_of_marked_mines
    number_of_items(@player_board, MARK)
  end

  def number_of_mines
    number_of_items(@solution, MINE)
  end

  def number_of_items(board, item)
    items = 0
    board.each { |x| x.each { |y| items += 1 if y == item } }
    items
  end

  # User has win
  def win
    title
    show_solution
    puts 'You win!!'.green
    true
  end

  # Show all zeros around the checked position (x, y)
  def show_zeros(row, col)
    positions(row, col).map do |x, y|
      next unless @solution[x] && x >= 0 && y >= 0
      if @solution[x][y] == '0' && @player_board[x][y] == FIELD
        @player_board[x][y] = @solution[x][y]
        show_zeros(x, y)
      elsif @solution[x][y] != MINE && @player_board[x][y] == FIELD
        @player_board[x][y] = @solution[x][y]
      end
    end
  end

  def mark_mine(row, col)
    return unless @solution[row] && row >= 0 && col >= 0
    @player_board[row][col] = MARK
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end
end
