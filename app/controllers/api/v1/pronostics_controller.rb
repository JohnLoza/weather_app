module Api
  module V1
    class PronosticsController < ApiController
      def search
        result = PronosticService.call(params[:query])
        if result[:success]
          render(json: success_response(result[:data]))
        else
          render(json: error_response(result[:error]))
        end
      end
    end
  end
end
