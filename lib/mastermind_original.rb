# Constacts
ITEMS = '1 2 3 4 5 6 7 8'.split
MAX_ATTEMPTS = 10
COMBINATION = 4

# MasterMind class
class MasterMind
  attr_accessor :win_combination, :attempts

  def initialize
    init
  end

  def init
    @attempts = 0
    @win_combination = []
    (0...COMBINATION).each do |i|
      @win_combination[i] = ITEMS.sample(1).first
    end
    init_message
  end

  def show_combination(combination)
    combination.join(',').to_s
  end

  def init_message
    system 'clear'
    puts ' WELCOME TO MASTERMIND!!!!'
    draw_line
    puts " You have #{MAX_ATTEMPTS} attempts to find out the correct combination."
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

  def draw_line
    80.times { print '-' }
    puts
  end

  def read_option
    options = gets.chomp
    return [] if options.empty?
    options.split(',')
  end

  def check_command?(option)
    return false unless option
    case option.first
    when 'new', 'newgame', 'n'
      option.clear
      init
    when 'attempts', 'attempt', 'a'
      option.clear
      puts " ** Attempt number #{@attempts + 1} of #{MAX_ATTEMPTS} ** "
      draw_line
    when 'withdraw', 'w'
      option.clear
      lose
      return true unless playagain?
    when 'godmode', '!'
      option.clear
      puts " ** Winner combination: #{show_combination(@win_combination)} ** "
      draw_line
    when 'quit', 'exit', 'q'
      return true
    end
    false
  end

  def lose
    puts '  YOU LOSE!!'
    puts "  The correct answer was: #{show_combination(@win_combination)}."
  end

  def win
    puts '  YOU WIN!!!'
  end

  def check_items?(combination)
    check_cols = true
    combination.each { |col| check_cols &= ITEMS.include?(col) }
    check_cols
  end

  def check_combination?(combination)
    combination_cp = combination.dup
    win_combination_cp = @win_combination.dup
    hits = get_hits(combination, combination_cp, win_combination_cp)
    return true if hits == @win_combination.length
    partial_hits = partial_hits(combination_cp, win_combination_cp)
    puts " You have #{hits} correct hits and #{partial_hits} partial hits"
    draw_line
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

  def play
    while (combination = read_option)
      draw_line
      # Custom commands
      return false if check_command?(combination)
      next if combination.empty?
      # Check combination
      next unless play_combination?(combination)
      # Game finished. Play again?
      return false unless playagain?
      # initialize game
      init
    end
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
    #playagain?
    true
  end

  def evaluate?(combination)
    @attempts += 1
    puts " ** Attempt number #{@attempts} of #{MAX_ATTEMPTS} ** "
    if combination.length != COMBINATION
      puts " Invalid attempt. Ex: #{show_combination(ITEMS.sample(COMBINATION))}."
      puts ' Try again!'
    else
      return true if check_items?(combination)
      puts " Invalid items! Possible items: #{show_combination(ITEMS)}"
    end
    draw_line
    false
  end

  def playagain?
    draw_line
    puts 'Do you want to play again? (y/n)'
    answer = gets.chomp
    return false if answer != 'y'
    init
    true
  end
end

game = MasterMind.new
game.play
