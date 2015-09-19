require 'azure_mgmt_resources'

module JellyfishAzure
  module Provider
    class Azure < ::Provider
      def azure_locations
        [
          { label: "US East", value: "eastus" },
          { label: "US West", value: "westus" }
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
          tenantId = settings[:tenant_id]
          clientId = settings[:client_id]
          clientSecret = settings[:client_secret]
          token_provider = MsRestAzure::ApplicationTokenProvider.new(tenantId, clientId, clientSecret)
          MsRest::TokenCredentials.new(token_provider)
        end
      end

      def subscriptionId
        settings[:subscription_id]
      end
    end
  end
end
