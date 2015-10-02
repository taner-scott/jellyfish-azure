module JellyfishAzure
  module ProductType
    class ResourceGroup < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Resource Group', 'b9084b76-3757-40cb-91f4-f67bafb09a90', provider_type: 'JellyfishAzure::Provider::Azure')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAzure::ProductType::ResourceGroup')
          end
        end
      end

      def description
        'Azure Resource Group'
      end

      def tags
        'resource'
      end

      def product_questions
        [
          { name: :resource_group_name, value_type: :string, field: :azure_resource_group_name, required: true }
        ]
      end

      def order_questions
        [
          { name: :resource_name, value_type: :string, field: :azure_resource_name, required: true },
          { name: :resource_group_name, value_type: :string, field: :azure_resource_group_name, required: true },
          { name: :location, value_type: :string, field: :azure_location, required: true }
        ]
      end

      def service_class
        'JellyfishAzure::Service::ResourceGroup'.constantize
      end
    end
  end
end
