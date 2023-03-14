# frozen_string_literal: true

def load_dictionary(file)
  dictionary = File.open(file, 'r', &:readlines)
  dictionary.map(&:chomp)
end

def select_random_word(dictionary)
  # Selects a word between 5 and 12 characters
  dictionary.filter { |word| word.length > 4 && word.length < 13 }
  dictionary.sample
end

dictionary = load_dictionary('dictionary.txt')
word = select_random_word(dictionary)

guess = 'a'
chances_left = 5 # Represents the num of incorrect guesses allowed

# Counts the remaining incorrect guesses
chances_left -= 1 unless word.include?(guess)

puts "Chances left: #{chances_left}"
