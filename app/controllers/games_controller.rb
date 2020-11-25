require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    grid = params[:grid].split(/["\s,]/)
    start = Time.new(params[:start])
    # raise
    @result = run_game(params[:suggestion], grid, start, Time.now)
  end

  private

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    lapse = end_time - start_time
    dict_answer = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    match_letters = attempt.upcase.chars.all? do |letra|
      grid.delete_at(grid.index(letra)) if grid.include?(letra)
    end
    if match_letters && dict_answer['found']
      { score: 100.0 / lapse + dict_answer['length'], time: lapse, message: 'Well Done' }
    else
      { score: 0, time: lapse, message: dict_answer['found'] ? 'not in the grid' : 'not an english word' }
    end
  end
end
