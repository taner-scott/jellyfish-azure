module JellyfishAzure
  module ProductType
    class StorageAccount < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Storage Account', 'fc464663-dad7-4466-b4ce-e942df07af7', provider_type: 'JellyfishAzure::Provider::Azure')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAzure::ProductType::StorageAccount')
          end
        end
      end

      def description
        'Azure Storage Account'
      end

      def tags
        %w(azure storage)
      end

      def product_questions
        [
          { name: :storage_accountType, value_type: :string, field: :azure_storage_accountType, required: true }
        ]
      end

      def order_questions
        [
          { name: :storage_name, value_type: :string, field: :azure_storage_name, required: true },
          { name: :resource_group_name, value_type: :string, field: :azure_resource_group_name, required: true },
          { name: :location, value_type: :string, field: :azure_location, required: true }
        ]
      end

      def service_class
        'JellyfishAzure::Service::StorageAccount'.constantize
      end
    end
  end
end
