module JellyfishAzure
  module Service
    class WebDevEnvironment < AzureService
      def self.locations
        [
          { label: 'US East', value: 'eastus' },
          { label: 'US West', value: 'westus' }
        ]
      end

      def service_initialize
        storage_account_check = check_storage_account settings[:az_dev_dns]

        unless storage_account_check.name_available
          fail ValidationError, storage_account_check.message
        end
      end

      def template_url
        'https://raw.githubusercontent.com/projectjellyfish/jellyfish-azure/master/templates/web-dev-environment/azuredeploy.json'
      end

      def location
        settings[:az_dev_location]
      end

      def template_parameters
        {
          serviceName: { value: resource_group_name },
          webTechnology: { value: product.settings[:az_dev_web] },
          dbTechnology: { value: product.settings[:az_dev_db] },
          dnsNameForPublicIP: { value: settings[:az_dev_dns] },
          adminUsername: { value: settings[:az_username] },
          adminPassword: { value: settings[:az_password] }
        }
      end

      private

      def storage_client
        @_storage_client ||= begin
          result = Azure::ARM::Storage::StorageManagementClient.new product.provider.credentials
          result.subscription_id = product.provider.subscription_id
          result
        end
      end

      def check_storage_account(name)
        parameters = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
        parameters.name = name
        parameters.type = 'Microsoft.Storage/storageAccounts'

        promise = storage_client.storage_accounts.check_name_availability parameters
        result = promise.value!
        result.body
      end
    end
  end
end
