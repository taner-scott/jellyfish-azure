require 'open-uri'

module JellyfishAzure
  module Product
    class CustomPublicTemplate < ::Product
      def order_questions
        @_order_questions ||= begin
          template_url = settings[:az_custom_template_uri]
          template_content = open(template_url).read
          @template = JellyfishAzure::Service::DeploymentTemplate.new template_content

          default_questions = [
            { label: 'Location', name: :az_custom_location, value_type: :string, field: :az_custom_location, required: true }
          ]

          template_questions = @template.get_questions 'az_custom_param_', ["templateBaseUrl", "sasToken", 'serviceName']

          default_questions + template_questions
        end
      end

      def service_class
        'JellyfishAzure::Service::CustomPublicTemplate'.constantize
      end
    end
  end
end

