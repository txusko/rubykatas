# Constacts
ITEMS = '1 2 3 4 5 6 7 8'.split
MAX_ATTEMPS = 10
COMBINATION = 4

# MasterMind class
class MasterMind
  attr_accessor :win_combination, :attemps

  def initialize
    init
  end

  def init
    @attemps = 0
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
    puts " You have #{MAX_ATTEMPS} attemps to find out the correct combination."
    puts " The combination is a random string composed by #{COMBINATION} " \
         'sepparated comma items.'
    print ' You can combine the following items one or more times:'
    puts " #{show_combination(ITEMS)}"
    puts " Example: #{show_combination(ITEMS.sample(COMBINATION))}"
    puts ' Game commands: '
    puts ' - new/newgame(finish current game and start a new one)'
    puts ' - endgame/end (end current game)'
    puts ' - attemp/attemps (show number of attemps)'
    puts ' - godmode (show winner combination)'
    puts ' - quit/exit (exit game)'
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
    when 'new', 'newgame'
      option.clear
      init
    when 'godmode'
      option.clear
      puts " ** Winner combination: #{show_combination(@win_combination)} ** "
    when 'attemps', 'attemp'
      option.clear
      puts " ** Attemp number #{@attemps + 1} of #{MAX_ATTEMPS} ** "
    when 'end', 'endgame'
      puts ' ** Game finished. ** '
      return true unless playagain?
      init
      option.clear
    when 'quit', 'exit'
      return true
    end
    false
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
    return false unless evaluate?(combination)
    return false unless check_attemps?(combination)
    return false unless check_combination?(combination)
    puts '  YOU WIN!!'
    true
  end

  def check_attemps?(combination)
    if @attemps >= MAX_ATTEMPS
      # Last combination atemp
      puts '  YOU WIN!!!' if check_combination?(combination)
      # User have lose the game
      puts "  The correct answer was: #{show_combination(@win_combination)}."
      puts '  YOU LOSE!!'
      return false
    end
    true
  end

  def evaluate?(combination)
    @attemps += 1
    puts " ** Attemps number #{@attemps} of #{MAX_ATTEMPS} ** "
    if combination.length != COMBINATION
      puts " Invalid attemp. Ex: #{show_combination(ITEMS.sample(COMBINATION))}."
      puts ' Try again!'
    else
      return true if check_items?(combination)
      puts " Invalid items! Possible items: #{show_combination(ITEMS)}"
    end
    false
  end

  def playagain?
    puts 'Do you want to play again? (y/n)'
    answer = gets.chomp
    (answer == 'y')
  end
end

game = MasterMind.new
game.play
