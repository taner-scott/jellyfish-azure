module JellyfishAzure
  class ApplicationController < ::ApplicationController
    rescue_from Exception, with: :azure_error

    protected

    def azure_error(ex)
      puts ex.to_s
      render json: {type: type, error: ex.to_s}, status: :bad_request
    end
  end
end
