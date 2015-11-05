module JellyfishAzure
  module Operation
    class CustomPrivateProvision < AzureProvisionOperation
      def initialize(cloud_client, provider, product, service)
        super cloud_client, provider, product, service
      end

      def setup
        storage_account_name = @product.settings[:az_custom_name]
        storage_account_key = @product.settings[:az_custom_key]
        storage_account_container = @product.settings[:az_custom_container]
        storage_account_blob = @product.settings[:az_custom_blob]

        content = @cloud_client.storage.get_blob storage_account_name, storage_account_key, storage_account_container, storage_account_blob

        @template = JellyfishAzure::Cloud::DeploymentTemplate.new content
      rescue ::Azure::Core::Error => e
        raise ValidationError, "There was a problem accessing the template: #{e.message}"
      end

      def template_url
        @template_url ||= begin
          storage_account_name = @product.settings[:az_custom_name]
          storage_account_key = @product.settings[:az_custom_key]
          storage_account_container = @product.settings[:az_custom_container]
          storage_account_blob = @product.settings[:az_custom_blob]

          @cloud_client.storage.get_blob_sas_uri storage_account_name, storage_account_key, storage_account_container,
            storage_account_blob, 30
        end
      end

      def location
        @service.settings[:az_custom_location]
      end

      def template_parameters
        template_parameters = @template.apply_parameters 'az_custom_param_', @service.settings

        base_parameters = {
          templateBaseUrl: { value: URI.join(template_url, '.').to_s },
          sasToken: { value: URI(template_url).query },
          serviceName: { value: resource_group_name }
        }

        base_parameters.merge template_parameters
      end
    end
  end
end
