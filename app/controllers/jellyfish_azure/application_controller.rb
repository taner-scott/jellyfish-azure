module JellyfishAzure
  class ApplicationController < ::ApplicationController
    rescue_from Exception, with: :azure_error

    protected

    def azure_error(ex)
      render json: { error: ex.to_s }, status: :bad_request
    end
  end
end
