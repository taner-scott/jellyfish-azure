module JellyfishAzure
  module Service
    class AzureDeploymentErrors < StandardError
      # @return [Array] the varioud  response body.
      attr_accessor :errors

      def initialize(deployment_operations)
        @errors = deployment_operations.value
                  .select { |item| item.properties.provisioning_state == 'Failed' }
                  .map { |item| AzureDeploymentError.new(item) }
      end
    end
  end
end
