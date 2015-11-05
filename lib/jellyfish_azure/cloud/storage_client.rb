module JellyfishAzure
  module Cloud
    class StorageClient
      def initialize(credentials, subscription_id)
          @client = ::Azure::ARM::Storage::StorageManagementClient.new credentials
          @client.subscription_id = subscription_id
      end

      def check_name_availability(name)
        parameters = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
        parameters.name = name
        parameters.type = 'Microsoft.Storage/storageAccounts'

        promise = @client.storage_accounts.check_name_availability parameters
        result = promise.value!

        [ result.body.name_available, result.body.message ]
      end
    end
  end
end
# get blob
# get blob sas
# validate blob
