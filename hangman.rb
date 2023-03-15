# frozen_string_literal: true

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
    gets.chomp.downcase
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
end

Game.new('dictionary.txt').play
