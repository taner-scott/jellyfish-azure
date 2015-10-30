require 'open-uri'

module JellyfishAzure
  module Product
    class CustomPublicTemplate < JellyfishAzure::Product::AzureProduct
      EXCLUDE_PARAMS = %w(templateBaseUrl serviceName)

      def parameter_values(parameter_name)
        # TODO: figure out a way to avoid downloading the template over and over
        template_url = settings[:az_custom_template_uri]
        template_content = open(template_url).read
        @template = JellyfishAzure::Service::DeploymentTemplate.new template_content

        @template.find_allowed_values parameter_name
      end

      def order_questions
        @_order_questions ||= begin
          template_url = settings[:az_custom_template_uri]
          template_content = open(template_url).read
          @template = JellyfishAzure::Service::DeploymentTemplate.new template_content

          default_questions = [
            { label: 'Location', name: :az_custom_location, value_type: :string, field: :az_location, required: true }
          ]

          template_questions = @template.get_questions 'az_custom_param_', EXCLUDE_PARAMS

          default_questions + template_questions
        end
      end

      def service_class
        'JellyfishAzure::Service::CustomPublicTemplate'.constantize
      end
    end
  end
end
