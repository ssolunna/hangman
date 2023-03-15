# frozen_string_literal: true

def load_dictionary(file)
  dictionary = File.open(file, 'r', &:readlines)
  dictionary.map(&:chomp)
end

def select_random_word(dictionary)
  # Selects a word between 5 and 12 characters
  dictionary.filter { |word| word.length > 4 && word.length < 13 }.sample
end

def display_word(word, guess)
  print ' Word: '
  puts word.gsub(/[^#{guess}]/, '_') # Display only the correct letter guess
end

def display_incorrect_letters(word, guess)
  wrong_guesses = []
  wrong_guesses << guess unless word.include?(guess)
  puts "Wrong guesses: '#{wrong_guesses.join}'"
end

dictionary = load_dictionary('dictionary.txt')

word = select_random_word(dictionary)

chances_left = 5 # Represents the num of incorrect guesses allowed

guess = 'a'

display_word(word, guess)

# Counts the remaining incorrect guesses
chances_left -= 1 unless word.include?(guess)

puts "Chances left: #{chances_left}"

display_incorrect_letters(word, guess)
