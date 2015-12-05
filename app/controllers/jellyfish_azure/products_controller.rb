module JellyfishAzure
  class ProductsController < JellyfishAzure::ApplicationController
    after_action :verify_authorized
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def locations
      authorize :azure

      fail ActionController::RoutingError, 'Not Found' unless product.methods.include? :valid_locations

      render json: product.valid_locations
    end

    def parameter_values
      authorize :azure

      fail ActionController::RoutingError, 'Not Found' unless product.methods.include? :parameter_values

      parameter_values = product.parameter_values params[:parameter]
      fail ActionController::RoutingError, 'Not Found' if parameter_values.nil?

      render json: parameter_values
    end

    private

    def product
      @product ||= ::Product.find params[:id]
    end
  end
end
