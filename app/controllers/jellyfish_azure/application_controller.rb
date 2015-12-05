module JellyfishAzure
  class ApplicationController < ::ApplicationController
    rescue_from Exception, with: :azure_error

    protected

    def azure_error(ex)
      logger.debug ex.to_s
      render json: { error: 'Unexpected error' }, status: 500
    end

    def not_found
      render status: 404, json: { error: 'Not Found' }
    end
  end
end
