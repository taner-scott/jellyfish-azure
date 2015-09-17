class ProductType < ActiveRecord::Base
  class StorageAccount < ProductType
    def self.load_product_types
      return unless super

      transaction do
        [
          set('Storage Account', 'fc464663-dad7-4466-b4ce-e942df07af7', provider_type: 'Provider::Azure')
        ].each do |s|
          create! s.merge!(type: 'ProductType::StorageAccount')
        end
      end
    end

    def description
      'Azure Storage Account'
    end

    def tags
      ['azure', 'storage']
    end

    def product_questions
      [
        { name: :storage_accountType, value_type: :string, field: :azure_storage_accountType, required: true }
      ]
    end

    def order_questions
      [
        { name: :location, value_type: :string, field: :azure_location, required: true }
      ]
    end

    def service_class
      'Service::StorageAccount'.constantize
    end
  end
end
