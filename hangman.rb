# frozen_string_literal: true

def load_dictionary(file)
  dictionary = File.open(file, 'r', &:readlines)
  dictionary.map(&:chomp)
end

def select_random_word(dictionary)
  # Selects a word between 5 and 12 characters
  dictionary.filter { |word| word.length > 4 && word.length < 13 }.sample
end

def display_word(word, correct_letters)
  print ' Word: '

  if correct_letters.empty?
    word.length.times { print '_' }
  else
    # Displays only the correct letter guess
    print word.gsub(/[^#{correct_letters.join}]/, '_')
  end

  puts
end

def make_guess
  print 'Guess: '
  gets.chomp.downcase
end

def player_won?(word, correct_letters)
  word.split('').all? { |word_letter| correct_letters.include?(word_letter) }
end

def play(word, chances, incorrect_letters, correct_letters)
  until chances.zero? || player_won?(word, correct_letters)
    guess = make_guess

    if word.include?(guess)
      correct_letters << guess unless correct_letters.include?(guess)
    else
      chances -= 1 # Counts the remaining incorrect guesses
      incorrect_letters << guess unless incorrect_letters.include?(guess)
    end

    display_word(word, correct_letters)

    puts "Wrong guesses: '#{incorrect_letters.join(' ')}'"

    puts "Chances left: #{chances}"
  end
end

dictionary = load_dictionary('dictionary.txt')

word = select_random_word(dictionary)

chances = 5 # Represents the num of incorrect guesses allowed

correct_letters = []

incorrect_letters = []

play(word, chances, incorrect_letters, correct_letters)
