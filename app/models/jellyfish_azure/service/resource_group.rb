module JellyfishAzure
  module Service
    class ResourceGroup < ::Service::Resource
      def actions
        actions = super.merge :terminate

        # determine if action is available

        actions
      end

      def provision order, product
        # Create a client - a point of access to the API and set the subscription id
        client = Azure::ARM::Resources::ResourceManagementClient.new(product.provider.credentials)
        client.subscription_id = product.provider.subscriptionId

        # Create a model for new resource group account.
        properties = Azure::ARM::Resources::Models::ResourceGroupPropertiesCreateParameters.new
        properties.account_type = product.settings[:resource_group_accountType]

        params = Azure::ARM::Resources::Models::ResourceGroupCreateParameters.new
        params.properties = properties
        params.location = order.settings[:location]

        promise = client.resource_group.create(order.settings[:resource_group_name], order.settings[:resource_name], params)

        result = promise.value!

        #Handle the result
        result.body

      end

      def terminate
      end
    end
  end
end
