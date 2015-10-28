module JellyfishAzure
  module ProductType
    class CustomPublicTemplate < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Custom template from the Internet', 'c03e94a2-940e-4d75-ae99-6bd6f7a4d958', provider_type: 'JellyfishAzure::Provider::Azure')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAzure::ProductType::CustomPublicTemplate')
          end
        end
      end

      def description
        'Uses an existing Azure Resource Manager Deployment template from a public location'
      end

      def tags
        %w(storage cdn)
      end

      def product_questions
        [
          { label: 'Template URI', name: :az_custom_template_uri, value_type: :string, field: :text, required: true }
        ]
      end

      def product_class
        'JellyfishAzure::Product::CustomPublicTemplate'.constantize
      end
    end
  end
end
