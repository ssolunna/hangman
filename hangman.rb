# frozen_string_literal: true

require 'json'

# Hangman
class Game
  def initialize(dictionary)
    display_intro
    puts

    return if File.exist?('saved_game.json') && load_saved_game?

    @dictionary = load_dictionary(dictionary)
    @word = select_random_word(@dictionary)
    @chances = 5 # Num of incorrect guesses allowed
    @correct_letters = []
    @incorrect_letters = []
  end

  def display_intro
    puts ' Game: Hangman'
    puts 'About: Guess a computer generated word by typing letters'
    puts '       within a certain number of guesses (chances).'
    puts 'Rules: - You can only type 1 letter per guess'
    puts '       - Type "save" if you want to save the current game'
  end

  def play
    until @chances.zero? || player_won?
      display_layout

      guess = make_guess

      return if guess.nil?

      puts

      log_guess(guess)
    end

    display_layout

    puts
    puts player_won? ? 'Congrats! You guessed it.' : 'You run out of guesses.'
  end

  def load_dictionary(file)
    File.open(file, 'r', &:readlines).map(&:chomp)
  end

  def select_random_word(dictionary)
    # Selects a word between 5 and 12 characters
    dictionary.filter { |word| word.length > 4 && word.length < 13 }.sample
  end

  def display_layout
    display_word

    print "  ||  Chances left: #{@chances}"

    puts "  ||  Wrong guesses: '#{@incorrect_letters.join(' ')}'"
  end

  def display_word
    print ' Word: '

    if @chances.zero?
      print @word
    elsif @correct_letters.empty?
      @word.length.times { print '_' }
    else
      # Displays only the correct letter guess
      print @word.gsub(/[^#{@correct_letters.join}]/, '_')
    end
  end

  def make_guess
    print 'Guess: '
    guess = gets.chomp.downcase

    case guess
    when 'save'
      save_game
    when /^[a-z]$/ # If is a word character
      guess
    else
      puts
      puts "Couldn't validate your guess. Try again."
      make_guess
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
    File.open('saved_game.json', 'w') do |file|
      file.puts JSON.dump({
      word: @word,
      chances: @chances,
      correct_letters: @correct_letters,
      incorrect_letters: @incorrect_letters
      })
    end

    puts
    puts 'Game saved.', 'Exiting...'
  end

  def load_saved_game?
    print 'Saved game detected. Do you want to load it? [y|N]: '
    response = gets.chomp
    puts

    return unless response.downcase == 'y' || response.downcase == 'yes'

    load_game
    true
  end

  def load_game
    saved_game = JSON.parse(File.read('saved_game.json'))

    saved_game.each do |variable, value|
      instance_variable_set("@#{variable}", value)
    end

    File.delete('saved_game.json')
  end
end

Game.new('dictionary.txt').play
