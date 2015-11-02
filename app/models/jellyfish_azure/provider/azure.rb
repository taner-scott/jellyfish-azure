require 'azure_mgmt_resources'

module JellyfishAzure
  module Provider
    class Azure < ::Provider
      validate :validate_azure_connection

      def validate_azure_connection
        logger.debug "Validating provider settings for '#{name}'"

        # test the connection by listing a single provider
        client = ::Azure::ARM::Resources::ResourceManagementClient.new(credentials)
        client.subscription_id = subscription_id
        client.providers.list(1).value!

      rescue MsRestAzure::AzureOperationError => e
        logger.debug e.message
        errors.add :client_id, e.message
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
