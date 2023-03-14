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
