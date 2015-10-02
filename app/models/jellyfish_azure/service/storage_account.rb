module JellyfishAzure
  module Service
    class StorageAccount < ::Service::Storage
      def actions
        actions = super.merge :terminate

        # determine if action is available

        actions
      end

      def provision(order, product)
        # Create a client - a point of access to the API and set the subscription id
        client = Azure::ARM::Storage::StorageManagementClient.new(product.provider.credentials)
        client.subscription_id = product.provider.subscription_id

        # Create a model for new storage account.
        properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
        properties.account_type = product.settings[:storage_accountType]

        params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
        params.properties = properties
        params.location = order.settings[:location]

        promise = client.storage_accounts.create(order.settings[:resource_group_name], order.settings[:storage_name], params)

        result = promise.value!

        # Handle the result
        result.body
      end

      def terminate
      end
    end
  end
end
