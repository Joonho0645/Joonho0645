class QuestionsController < ApplicationController

  def answer
    @input = params[:input]
    @answer = get_answer(@input)
  end

  def get_answer(input)
    if input == "I am going to work right now!"
      return "Great!"
    elsif input.to_s.include? "?"
      return "Silly question, get dressed and go to work!"
    else
      return "I don't care, get dressed and go to work!"
    end
  end

  def ask
  end
end
