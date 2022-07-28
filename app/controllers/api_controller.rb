class ApiController < ActionController::API
  respond_to? :json

  include StandardResponse
end
