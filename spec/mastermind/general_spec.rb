require 'spec_helper'
require 'mastermind'

describe 'general' do
  before do
    @game = MasterMind.new
  end
  it 'initialized game' do
    expect(@game.attempts).to eq(0)
    expect(@game.win_combination).to_not be_nil
  end

  it 'correct winner combination' do
    expect(@game.win_combination.length).to be(COMBINATION)
    @game.win_combination.each do |item|
      expect(ITEMS.include?(item)).to be true
    end
  end

  it 'read line' do
    combination = '1,1,1,1'
    expected = combination.split(',')
    expect(@game.read_option(combination)).to eq(expected)
  end

  it 'check correct number of attempts' do
    combination = 'error'
    (0...MAX_ATTEMPTS).each do
      expect(@game.play_combination?(combination)).to be false
    end
    expect(@game.attempts).to eq(MAX_ATTEMPTS)
  end

  it 'check new game' do
    last_win_combination = @game.win_combination.dup
    @game.new_game
    expect(@game.win_combination).to_not eq(last_win_combination)
  end

  it 'win the game' do
    winner_combination = @game.win_combination
    expect(@game.play_combination?(winner_combination)).to be true
  end
end
