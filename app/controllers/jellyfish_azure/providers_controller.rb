
module JellyfishAzure
  class ProvidersController < JellyfishAzure::ApplicationController
    after_action :verify_authorized

    def azure_locations
      authorize :azure
      results = provider.azure_locations
      render json: results
    end

    def azure_resource_groups
      authorize :azure
      render json: provider.azure_resource_groups
    end

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
