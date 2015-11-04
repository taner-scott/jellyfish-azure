module JellyfishAzure
  module Operation
    class AzureDeploymentError
      attr_reader :error_message

      def initialize(error_message)
        @error_message = error_message
      end
    end
  end
end
