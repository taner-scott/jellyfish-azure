
module JellyfishAzure
  class ProvidersController < JellyfishAzure::ApplicationController
    after_action :verify_authorized

    def web_dev_locations
      authorize :azure
      render json: Service::WebDevEnvironment.locations
    end

    private

    def provider
      @provider ||= ::Provider.find params[:id]
    end
  end
end
