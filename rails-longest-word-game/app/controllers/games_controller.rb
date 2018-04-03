require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # urls
  def new
    # *1* for e.g. the grid to be accessible in the calcscore page, we need to pass it
    # in the playgame page through the form to the params:
    @grid = generate_grid
    @start_time = Time.now
  end

  def score
    # *3* for e.g. the grid to be accessible in the calcscore page, we need to pass it
    # in the playgame page through the form to the params + back to array again
    grid = params[:grid].split("")
    @attempt = params[:attempt]
    start_time = Time.parse(params[:start_time])
    attempt_time = (Time.now - start_time).round
    @score = calc_score(attempt_time, @attempt, grid)
    @translation = get_translation(@attempt)
    @message = show_message(@attempt, grid)
    # only use an instance variable @ here if you want to be able to show it in this page's view (calcscore)
  end

private
  # methods needed for urls - would be in model normally

  def generate_grid
  # TODO: generate random grid of letters
    grid = []
    10.times { grid << ('a'..'z').to_a[rand(26)] }
    grid
  end

  def calc_score(attempt_time, attempt, grid)
    # if attempt can't be found in english words, score should be zero
    # if attempt can't be made from the grid (letters used that are not in the grid), score should be zero
    # if attempt can't be made from the grid (letters used that are in the grid but nog often enough),
    #  score should be zero?
    if !english?(attempt) || !grid_occurence?(attempt, grid)
      0
    # else calculate score: should be higher for longer word and higher for shorter attempttime
    else
      attempt.length + (1000 - attempt_time)
    end
  end

  def get_translation(attempt)
  # if attempt can't be found in english words, return nil translation
    if !english?(attempt)
      return nil
    # else consider first translation from wordreference api in french and return
    else
      url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
      translations = open(url) { |stream| translations = JSON.parse(stream.read) }
      return translations.fetch("term0").fetch("PrincipalTranslations").fetch("0").fetch("FirstTranslation").fetch("term")
    end
  end

  def english?(attempt)
    # true is attempt can be found in english words (api), false if not
    url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
    translations = open(url) { |stream| translations = JSON.parse(stream.read) }
    translations.keys[0] == "Error" ? false : true
  end

  def grid_inclusion?(attempt, grid)
  # true if all attempt letters are in the grid (but doesn't say anything about the occurences)
  # note - test grid inclusion by Enumerable#all?
    attempt_arr = attempt.downcase.split("")
    grid = grid.map(&:downcase)
    attempt_arr.all? { |letter| grid.include? letter }
  end

  def grid_occurence?(attempt, grid)
    # true if all attempt letters are in the grid and in the right number of occurences
    return false unless grid_inclusion?(attempt, grid)
    gridclone = grid.dup.map(&:downcase)
    attempt.downcase.split("").all? do |letter|
      if gridclone.include? letter
        gridclone.delete_at(gridclone.index(letter))
        true
      else
        false
      end
    end
  end

  def show_message(attempt, grid)
    # if attempt can't be found in english words, build custom message
    return "not an english word" unless english?(attempt)
    # if attempt can't be made from the grid (letters used that are not in the grid),
    #  build custom message
    # if attempt can't be made from the grid (letters used that are in the grid but nog often enough),
    # return message that it's not in the grid
    if !grid_occurence?(attempt, grid)
      return "not in the grid"
    # if attempt is good catch, build custom message
    else
      return "well done"
    end
  end

end
