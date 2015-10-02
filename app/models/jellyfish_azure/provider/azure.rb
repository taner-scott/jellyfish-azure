require 'azure_mgmt_resources'

module JellyfishAzure
  module Provider
    class Azure < ::Provider
      def azure_locations
        [
          { label: 'US East', value: 'eastus' },
          { label: 'US West', value: 'westus' }
        ]
      end

      def azure_resource_groups
        client = ::Azure::ARM::Resources::ResourceManagementClient.new(credentials)
        client.subscription_id = subscriptionId

        promise = client.resource_groups.list
        result = promise.value!

        result.body.value.map do |resourceGroup|
          {
            label: resourceGroup.name,
            value: resourceGroup.name,
            group: resourceGroup.location
          }
        end
      end

      def credentials
        @credentials ||= begin
          tenant_id = settings[:tenant_id]
          client_id = settings[:client_id]
          client_secret = settings[:client_secret]
          token_provider = MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, client_secret)
          MsRest::TokenCredentials.new(token_provider)
        end
      end

      def subscription_id
        settings[:subscription_id]
      end
    end
  end
end
