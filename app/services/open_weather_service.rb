# frozen_string_literal: true

class OpenWeatherService < ApplicationService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  API_KEY = 'a5a47c18197737e8eeca634cd6acb581'
  EXCLUSIONS = %i[current minutely hourly alerts]

  attr_reader :lat, :lon

  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def call
    self.class.get(url_with_params)
  rescue SocketError
    error_response('OpenWeather API service is unavailable')
  end

  private

  def exclusions
    EXCLUSIONS.join(',')
  end

  def url_with_params
    "/onecall?lat=#{lat}&lon=#{lon}&exclude=#{exclusions}&appid=#{API_KEY}"
  end
end
