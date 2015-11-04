module JellyfishAzure
  module Operation
    class AzureDeploymentErrors < StandardError
      # @return [Array] the varioud  response body.
      attr_accessor :errors

      def initialize(errors)
        @errors = errors
      end
    end
  end
end
