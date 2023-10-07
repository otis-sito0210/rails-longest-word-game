require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      random_letter = ('a'..'z').to_a.sample
      @letters << random_letter
    end
  end

  def score
    word = params[:word]
    letters = params[:letters].split

    valid_word = word.chars.all? { |letter| letters.include?(letter) }
    english_word = check_english_word(word)

    if valid_word
      if english_word
        @result = "Congratulations! #{word} is a valid word!"
      else
        @result = "Sorry, #{word} is not a valid English word!"
      end
    else
      @result = "#{word} can't be built with #{letters.join(', ')}"
    end
  end

  def check_english_word(word)
    url = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')

    request = Net::HTTP::Get.new(url.request_uri)

    response = http.request(request)

    if response.code == '200'
      data = JSON.parse(response.body)
      if data['found']
        return true
      else
        return false
      end
    end
  end
end
