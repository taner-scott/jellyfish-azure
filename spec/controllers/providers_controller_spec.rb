require 'rails_helper'

module JellyfishAzure
  describe ProvidersController, :type => :controller do
    routes { JellyfishAzure::Engine.routes }

    before(:each) do
    end

    describe "GET azure_locations" do
      before(:each) do
        JellyfishAzure::RegisteredProvider::Azure.load_registered_providers
        registeredProvider = ::RegisteredProvider.find_by uuid: "ea9db5ef-c0fd-458e-95c4-5005517b2bf6"
        @provider = create(:provider,
          name: "TestAzureProvider",
          type: "JellyfishAzure::Provider::Azure",
          registered_provider: registeredProvider)
        sign_in create(:staff)
      end

      it "has a 200 status code" do
        get :azure_locations, { :id => @provider.id }

        expect(response.status).to eq(200)
        expect(response.body).to eq([
          { label: 'US East', value: 'eastus' },
          { label: 'US West', value: 'westus' }
        ].to_json)
      end
    end
  end
end

