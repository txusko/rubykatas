# Constants
ITEMS = '1 2 3 4 5 6 7 8'.split
MAX_ATTEMPTS = 10
COMBINATION = 4

# MasterMind class
class MasterMind
  attr_accessor :win_combination, :attempts

  def initialize
    new_game
  end

  def new_game
    @attempts = 0
    @win_combination = []
    (0...COMBINATION).each do |i|
      @win_combination[i] = ITEMS.sample(1).first
    end
    welcome
  end

  def welcome
    system 'clear'
    puts ' WELCOME TO MASTERMIND!!!!'
    draw_line
    puts " You have #{MAX_ATTEMPTS} attempts to find out the correct " \
         'combination.'
    puts " The combination is a random string composed by #{COMBINATION} " \
         'sepparated comma items.'
    print ' You can combine the following items one or more times:'
    puts " #{show_combination(ITEMS)}"
    puts " Combination example: #{show_combination(ITEMS.sample(COMBINATION))}"
    puts ' Additional game commands: '
    puts ' - new/newgame/n (finish current game and start a new one)'
    puts ' - attempt/attempts/a (show number of attempts)'
    puts ' - withdraw/w (give up game)'
    puts ' - godmode/! (show winner combination)'
    puts ' - quit/exit/q (exit game)'
    draw_line
    puts ' Enter a combination:'
  end

  def play
    while (combination = read_option(gets.chomp))
      draw_line
      # Custom commands
      return false if check_command?(combination)
      next if combination.empty?
      # Check combination
      next unless play_combination?(combination)
      # Game finished. Play again?
      return false unless playagain?
      # initialize game
      new_game
    end
  end

  def read_option(options)
    return [] if options.empty?
    options.split(',')
  end

  def check_command?(option)
    return false unless option
    case option.first
    when 'new', 'newgame', 'n'
      option.clear
      new_game
    when 'attempts', 'attempt', 'a'
      option.clear
      draw_line(" ** Attempt number #{@attempts + 1} of #{MAX_ATTEMPTS} ** ")
    when 'withdraw', 'w'
      option.clear
      lose
      return true unless playagain?
    when 'godmode', '!'
      option.clear
      draw_line(' ** Winner combination: ' \
                "#{show_combination(@win_combination)} ** ")
    when 'quit', 'exit', 'q'
      return true
    end
    false
  end

  def play_combination?(combination)
    if @attempts >= MAX_ATTEMPTS
      # Check last combination
      check_combination?(combination) ? win : lose
    else
      return false unless evaluate?(combination)
      return false unless check_combination?(combination)
      win
    end
    # playagain?
    true
  end

  def check_combination?(combination)
    combination_cp = combination.dup
    win_combination_cp = @win_combination.dup
    hits = get_hits(combination, combination_cp, win_combination_cp)
    return true if hits == @win_combination.length
    partial_hits = partial_hits(combination_cp, win_combination_cp)
    draw_line(" You have #{hits} correct hits and #{partial_hits} partial hits")
    false
  end

  def get_hits(combination, combination_cp, win_combination_cp)
    hits = 0
    @win_combination.each_with_index do |car, index|
      next unless car == combination[index]
      combination_cp[index] = 'X'
      win_combination_cp[index] = 'X'
      hits += 1
    end
    hits
  end

  def partial_hits(combination_cp, win_combination_cp)
    partial_hits = 0
    combination_cp.each do |car|
      if car != 'X' && win_combination_cp.include?(car)
        win_combination_cp[win_combination_cp.index(car)] = 'X'
        partial_hits += 1
      end
    end
    partial_hits
  end

  def evaluate?(combination)
    @attempts += 1
    puts " ** Attempt number #{@attempts} of #{MAX_ATTEMPTS} ** "
    if combination.length != COMBINATION
      puts ' Wrong combination.'
    else
      return true if check_items?(combination)
      puts ' One or more items are invalid. Possible items: ' \
           "#{show_combination(ITEMS)}."
    end
    draw_line(' Try again!')
    false
  end

  def check_items?(combination)
    check_cols = true
    combination.each { |col| check_cols &= ITEMS.include?(col) }
    check_cols
  end

  def lose
    puts '  YOU LOSE!!'
    puts "  The correct answer was: #{show_combination(@win_combination)}."
  end

  def win
    puts '  YOU WIN!!!'
  end

  def playagain?
    draw_line(nil, 'Do you want to play again? (y/n)')
    answer = gets.chomp
    return false if answer != 'y'
    new_game
    true
  end

  def draw_line(before = nil, after = nil)
    puts before unless before.nil?
    80.times { print '-' }
    puts
    puts after unless after.nil?
  end

  def show_combination(combination)
    combination.join(',').to_s
  end
end

