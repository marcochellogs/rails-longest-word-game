require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    8.times { @letters << ('a'..'z').to_a.sample }
    if session.has_key?(:score_cookies)
      @user_score = session[:score_cookies]
    else
      @user_score = 0
    end
  end

  def cookies(score)
    if session.has_key?(:score_cookies)
      session[:score_cookies] += score
    else
      session[:score_cookies] = score
    end
    session[:score_cookies]
  end

  def score
    @word = params[:word]
    api_answer = URI.parse("https://wagon-dictionary.herokuapp.com/#{@word}").read
    @parsed = JSON.parse(api_answer)
    @word_score = 0
    valid_letters = true
    number_of_lett = true
    @letters_p = params[:letters]

    if @parsed["found"] == true
      @word_s = @word.split
      valid_letters = @word_s.each { |letter| false if !@letters_p.include?(letter) } #check that the letters used are valid
      number_of_lett =  @word_s.each { |letter| false if @letters_p.count(letter) < @word.count(letter) }

      if valid_letters && number_of_lett
        @word_score = @parsed["length"] * 10
        @answer_message = "Congratulations, you scored #{@word_score} points"
        @user_score = cookies(@word_score)
      end

    else
      @word_score = 'Not a valid word'
      @answer_message = @word_score
      @user_score = cookies(0)
    end
    @beginning = @letters_p.split(" ")
  end
end
