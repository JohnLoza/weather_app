# frozen_string_literal: true

class ReservamosPlacesService < ApplicationService
  include HTTParty
  base_uri 'https://search.reservamos.mx/api/v2'
  FROM = 'monterrey'

  attr_reader :query

  def initialize(query)
    @query = query
  end

  def call
    response = self.class.get(url_with_params)
    from_response = self.class.get(from_url_with_params)
    from_response.select! { |place| place['slug'] == FROM }
    full_response = [*from_response, *response]
    success_response(full_response)
  rescue SocketError
    error_response('Reservamos Places API service is unavailable')
  end

  private

  def url_with_params
    "/places?q=#{@query}&from=#{FROM}"
  end

  def from_url_with_params
    "/places?q=#{FROM}"
  end
end
