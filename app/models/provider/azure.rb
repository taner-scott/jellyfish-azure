class Provider < ActiveRecord::Base
  class Azure < Provider
    def azure_locations
      [
        { label: "US East", value: "eastus" },
        { label: "US West", value: "westus" }
      ]
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
