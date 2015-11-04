module JellyfishAzure
  module Operation
    class CustomPublicProvision < AzureOperation
      def initialize(cloud_client, provider, product, service)
        super cloud_client, provider, product, service
      end

      def setup
        template_content = open(template_url).read

        @template = JellyfishAzure::Cloud::DeploymentTemplate.new template_content
      rescue OpenURI::HTTPError => e
        raise ValidationError, e.message
      end

      def template_url
        @product.settings[:az_custom_template_uri]
      end

      def location
        @service.settings[:az_custom_location]
      end

      def template_parameters
        template_parameters = @template.apply_parameters 'az_custom_param_', @service.settings

        base_parameters = {
          templateBaseUrl: { value: URI.join(template_url, '.').to_s },
          serviceName: { value: resource_group_name }
        }

        base_parameters.merge template_parameters
      end


    end
  end
end
