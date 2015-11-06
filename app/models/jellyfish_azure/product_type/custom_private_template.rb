module JellyfishAzure
  module ProductType
    class CustomPrivateTemplate < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Custom template from private Blob Storage', '184480e8-7a51-4144-a0e6-a8564cfca752', provider_type: 'JellyfishAzure::Provider::Azure')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAzure::ProductType::CustomPrivateTemplate')
          end
        end
      end

      def description
        'Uses an existing Azure Resource Manager Deployment template from either a public location or private Azure
blob storage'
      end

      def tags
        %w(storage cdn)
      end

      def product_questions
        JellyfishAzure::Definition::CustomPrivateTemplateDefinition.product_questions
      end

      def product_class
        'JellyfishAzure::Product::CustomPrivateTemplate'.constantize
      end
    end
  end
end
