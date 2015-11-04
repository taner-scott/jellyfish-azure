module JellyfishAzure
  module Operation
    class WebDevEnvironmentProvision < AzureOperation
      def initialize(cloud_client, provider, product, service)
        super cloud_client, provider, product, service
      end

      def setup
        storage_account_check = check_storage_account @service.settings[:az_dev_dns]

        unless storage_account_check.name_available
          fail ValidationError, storage_account_check.message
        end
      end

      def template_url
        'https://raw.githubusercontent.com/projectjellyfish/jellyfish-azure/master/templates/web-dev-environment/azuredeploy.json'
      end

      def location
        @service.settings[:az_custom_location]
      end

      def template_parameters
        {
          serviceName: { value: resource_group_name },
          webTechnology: { value: @product.settings[:az_dev_web] },
          dbTechnology: { value: @product.settings[:az_dev_db] },
          dnsNameForPublicIP: { value: @service.settings[:az_dev_dns] },
          adminUsername: { value: @service.settings[:az_username] },
          adminPassword: { value: @service.settings[:az_password] }
        }
      end

      private

      def check_storage_account(name)
        storage_client = Azure::ARM::Storage::StorageManagementClient.new @provider.credentials
        storage_client.subscription_id = @provider.subscription_id

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
