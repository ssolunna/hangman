# frozen_string_literal: true

require 'json'

class Game
  def initialize(dictionary)
    @dictionary = load_dictionary(dictionary)
    @word = select_random_word(@dictionary)
    @chances = 5 # Num of incorrect guesses allowed
    @correct_letters = []
    @incorrect_letters = []
  end

  def play
    until @chances.zero? || player_won?
      guess = make_guess

      return if guess.nil?

      log_guess(guess)

      display_word

      puts "Wrong guesses: '#{@incorrect_letters.join(' ')}'"

      puts "Chances left: #{@chances}"
    end
  end

  def load_dictionary(file)
    File.open(file, 'r', &:readlines).map(&:chomp)
  end

  def select_random_word(dictionary)
    # Selects a word between 5 and 12 characters
    dictionary.filter { |word| word.length > 4 && word.length < 13 }.sample
  end

  def display_word
    print ' Word: '

    if @correct_letters.empty?
      @word.length.times { print '_' }
    else
      # Displays only the correct letter guess
      print @word.gsub(/[^#{@correct_letters.join}]/, '_')
    end

    puts
  end

  def make_guess
    print 'Guess: '
    guess = gets.chomp.downcase

    if guess == 'save'
      save_game
      nil
    else
      guess
    end
  end

  def log_guess(guess)
    if @word.include?(guess)
      @correct_letters << guess unless @correct_letters.include?(guess)
    else
      @chances -= 1
      @incorrect_letters << guess unless @incorrect_letters.include?(guess)
    end
  end

  def player_won?
    @word.split('').all? { |word_letter| @correct_letters.include?(word_letter) }
  end

  def save_game
    File.open('saved_game.txt', 'w') do |file|
      file.puts JSON.dump({
      word: @word,
      chances: @chances,
      correct_letters: @correct_letters,
      incorrect_letters: @incorrect_letters
      })
    end

    puts 'Game saved.', 'Exiting...'
  end
end

Game.new('dictionary.txt').play
