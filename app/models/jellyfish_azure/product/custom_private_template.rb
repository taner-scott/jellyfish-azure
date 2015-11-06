require 'azure'

module JellyfishAzure
  module Product
    class CustomPrivateTemplate < JellyfishAzure::Product::AzureProduct
      def template_definition
        @template_definition ||= JellyfishAzure::Definition::CustomPrivateTemplateDefinition.new provider.cloud_client, self
      end

      validate :validate_product

      def validate_product
        template_definition.template.validate
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
        'JellyfishAzure::Service::CustomPrivateTemplate'.constantize
      end
    end
  end
end
