# frozen_string_literal: true

class ReservamosPlacesService < ApplicationService
  include HTTParty
  base_uri 'https://search.reservamos.mx/api/v2'

  attr_reader :query

  def initialize(query)
    @query = query
  end

  def call
    self.class.get(url_with_params)
  rescue SocketError
    error_response('Reservamos Places API service is unavailable')
  end

  private

  def url_with_params
    "/places?q=#{@query}"
  end
end
