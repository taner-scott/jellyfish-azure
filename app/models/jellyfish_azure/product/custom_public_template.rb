require 'open-uri'

module JellyfishAzure
  module Product
    class CustomPublicTemplate < JellyfishAzure::Product::AzureProduct
      def template_definition
        @template_definition ||= JellyfishAzure::Definition::CustomPublicTemplateDefinition.new provider.cloud_client, self
      end

      validate :validate_product

      def validate_product
        template_definition.template
      rescue JellyfishAzure::ValidationError => e
        errors.add e.field || :base, e.message
      end

      def parameter_values(parameter_name)
        template_definition.parameter_values parameter_name
      end

      def order_questions
        template_definition.order_questions
      end

      def service_class
        'JellyfishAzure::Service::CustomPublicTemplate'.constantize
      end
    end
  end
end
