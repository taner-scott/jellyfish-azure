module JellyfishAzure
  class ProductsController < JellyfishAzure::ApplicationController
    after_action :verify_authorized

    def parameter_values
      authorize :azure
      fail ActionController::RoutingError, 'Not Found' unless product.methods.include? :parameter_values

      parameter_values = product.parameter_values params[:parameter]
      fail ActionController::RoutingError, 'Not Found' if parameter_values.nil?

      render json: parameter_values
    rescue ActionController::RoutingError
      render status: 404, json: { error: 'Not Found' }
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: { error: 'Not Found' }
    end

    private

    def product
      @product ||= ::Product.find params[:id]
    end
  end
end
