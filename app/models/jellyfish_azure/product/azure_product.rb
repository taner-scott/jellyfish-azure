module JellyfishAzure
  module Product
    class AzureProduct < ::Product
      def valid_locations
        [
          { label: 'US East', value: 'eastus' },
          { label: 'US West', value: 'westus' }
        ]
      end

    end
  end
end
