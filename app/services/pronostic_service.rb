# frozen_string_literal: true

class PronosticService < ApplicationService
  attr_reader :query, :places

  def initialize(query)
    @query = query
    @pronostics = []
  end

  def call
    @places = ReservamosPlacesService.call(@query)
    return error_response(@places[:error]) unless @places[:success]

    fill_pronostics
    @pronostics.any? ? success_response(@pronostics) : success_response([], 'no results found')
  end

  private

  def daily_pronostic(weather_result)
    weather_result[:data]['daily'].map do |daily_result|
      {
        min: daily_result['temp']['min'],
        max: daily_result['temp']['max']
      }
    end
  end

  def pronostic(place)
    weather_result = OpenWeatherService.call(place['lat'], place['long'])
    return nil unless weather_result[:success]

    {
      slug: place['city_slug'],
      city_name: place['city_name'],
      daily: daily_pronostic(weather_result)
    }
  end

  def filter_cities
    @places[:data].select! { |place| place['result_type'] == 'city' }
  end

  def fill_pronostics
    filter_cities
    @places[:data][0..2].each do |place|
      @pronostics << pronostic(place)
    end

    @pronostics.reject!(&:nil?)
  end
end
