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

  def date_plus_days(days_amount)
    date = Time.now + days_amount.days
    date.strftime('%a %d %b')
  end

  def daily_pronostic(weather_result)
    weather_result[:data]['daily'].map.with_index do |daily_result, index|
      {
        min: daily_result['temp']['min'],
        max: daily_result['temp']['max'],
        date: date_plus_days(index)
      }
    end
  end

  def pronostic(place)
    weather_result = OpenWeatherService.call(place['lat'], place['long'])
    return nil unless weather_result[:success]

    {
      slug: place['city_slug'],
      city: place['city_name'],
      state: place['state'],
      country: place['country'],
      daily: daily_pronostic(weather_result)
    }
  end

  def filter_by_country
    @places[:data].select! { |place| place['country'] == 'México' }
  end

  def filter_cities
    @places[:data].select! { |place| place['result_type'] == 'city' }
  end

  def fill_pronostics
    filter_by_country
    filter_cities
    @places[:data][0..2].each do |place|
      @pronostics << pronostic(place)
    end

    @pronostics.reject!(&:nil?)
  end
end
