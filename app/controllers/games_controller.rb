require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    letters = params[:letters]
    word = params[:word]
    @result = if !in_grid?(letters, word)
                "Sorry but #{word} can't be built out of #{letters}"
              elsif in_grid?(letters, word) && !english_word?(word)
                "Sorry but #{word} does not seem to be a valid English word."
              elsif in_grid?(letters, word) && english_word?(word)
                "Congratulations #{word} is a valid English word!"
              end
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    response = JSON.parse(word_serialized)
    response['found']
  end

  def in_grid?(letters, word)
    arr = letters.split
    letters.split.each do |letter|
      word.each_char do |char|
        arr.delete(letter) if letter == char
      end
    end
    arr.size == letters.split.size - word.size
  end
end
