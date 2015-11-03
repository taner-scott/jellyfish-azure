module JellyfishAzure
  module Operation
    class AzureDeploymentError
      # @return [Azure::ARM::Resources::Models::TargetResource] Gets or sets the target resource.
      attr_accessor :target_resource

      # @return [String] Gets or sets the error message.
      attr_accessor :error_message

      def initialize(deployment_operation)
        @target_resource = deployment_operation.properties.target_resource
        @error_message = deployment_operation.properties.status_message['error']['message']
      end
    end
  end
end
