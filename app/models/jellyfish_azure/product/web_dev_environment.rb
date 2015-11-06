module JellyfishAzure
  module Product
    class WebDevEnvironment < JellyfishAzure::Product::AzureProduct
      def template_definition
        @template_definition ||= JellyfishAzure::Definition::WebDevEnvironmentDefinition.new
      end

      def order_questions
        template_definition.order_questions
      end

      def service_class
        'JellyfishAzure::Service::WebDevEnvironment'.constantize
      end
    end
  end
end
