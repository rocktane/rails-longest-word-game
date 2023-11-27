require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    @word = params[:word].upcase
    @grid = params[:letters]

    grid_check = @word.chars.all? do |letter|
      @grid.count(letter) >= @word.chars.count(letter)
    end
    if grid_check == true
      dico_check(@word.downcase, @result)
    else
      @message = "Your word is not in the grid"
    end
  end

  def dico_check(attempt, result)
    if dictionary_compatible?(attempt) == true
      @message = "Well done, #{@word} is valid and you earn #{attempt.length ** 2}pts"
      if session[:secret].nil?
        session[:secret] = attempt.length ** 2
      else
        session[:secret] += attempt.length ** 2
      end
    else
      @message = "Sorry but #{@word} is not valid"
    end
  end

  def dictionary_compatible?(attempt)
    url_attempt = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    api_attempt = URI.open(url_attempt).read
    hash_attempt = JSON.parse(api_attempt)
    hash_attempt["found"]
  end
end
