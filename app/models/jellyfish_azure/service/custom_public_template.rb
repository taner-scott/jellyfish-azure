require 'azure'
require 'open-uri'

module JellyfishAzure
  module Service
    class CustomPublicTemplate < AzureService
      def service_initialize
        template_content = open(template_url).read

        @template = DeploymentTemplate.new template_content
      rescue OpenURI::HTTPError => e
        raise ValidationError, e.message
      end

      def template_url
        product.settings[:az_custom_template_uri]
      end

      def location
        settings[:az_custom_location]
      end

      def template_parameters
        template_parameters = @template.apply_parameters 'az_custom_param_', settings

        base_parameters = {
          templateBaseUrl: { value: URI.join(template_url, '.').to_s },
          serviceName: { value: resource_group_name }
        }

        base_parameters.merge template_parameters
      end
    end
  end
end
