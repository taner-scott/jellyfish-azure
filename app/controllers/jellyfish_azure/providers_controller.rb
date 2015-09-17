module JellyfishAzure
  class ProvidersController < JellyfishAws::ApplicationController
    after_action :verify_authorized

    def azure_locations
      authorize :azure
      render json: provider.azure_locations
    end

    private

    def provider
      @provider ||= Provider.find params[:id]
    end
  end
end
