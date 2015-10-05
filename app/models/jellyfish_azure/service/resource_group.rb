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

        # Create a model for resource group.
        resource_group = Azure::ARM::Resources::Models::ResourceGroup.new()
        resource_group.location = order.settings[:location]

        promise = client.resource_groups.create_or_update('new_test_resource_group', resource_group)

        result = promise.value!

        #Handle the result
        result.body

      end

      def terminate
      end
    end
  end
end
