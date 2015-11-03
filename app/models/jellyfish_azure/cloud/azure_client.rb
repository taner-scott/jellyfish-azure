require 'ms_rest_azure'
require 'azure_mgmt_storage'
require 'azure_mgmt_resources'

module JellyfishAzure
  module Cloud
    class AzureClient
      def initialize(credentials, subscription_id)
        @credentials = credentials
        @subscription_id = subscription_id
      end

      def resource_group
        @resource_group ||= ResourceGroupClient.new @credentials, @subscription_id
      end

      def deployment
        @deployment ||= DeploymentClient.new @credentials, @subscription_id
      end
    end
  end
end
