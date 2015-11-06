module JellyfishAzure
  module Definition
    class CustomPublicTemplateDefinition
      EXCLUDE_PARAMS = %w(templateBaseUrl serviceName)

      def self.product_questions
        [
          { label: 'Template URI', name: :az_custom_template_uri, value_type: :string, field: :text, required: true }
        ]
      end

      def initialize(cloud_client, product)
        @cloud_client = cloud_client
        @product = product
      end

      def template
        @template ||= download_template
      end

      def parameter_values(parameter_name)
        template.find_allowed_values parameter_name
      end

      def order_questions
        default_questions = [
          { label: 'Location', name: :az_location, value_type: :string, field: :az_location, required: true }
        ]

        template_questions = template.get_questions 'az_custom_param_', EXCLUDE_PARAMS

        default_questions + template_questions
      end

      private

      def download_template
        # download the file
        template_url = @product.settings[:az_custom_template_uri]
        content = open(template_url).read

        # parse the template
        JellyfishAzure::Cloud::DeploymentTemplate.new content
      rescue OpenURI::HTTPError => _
        # logger.debug e.message

        raise ValidationError.new 'The template URL provided could not be found', :az_custom_template_url
      rescue JSON::ParserError => _
        # logger.debug e.message

        raise ValidationError.new 'There was a problem parsing the template', :az_custom_template_url
      end
    end
  end
end
