module JellyfishAzure
  module Operation
    class CustomPrivateProvision < AzureOperation
      def initialize(cloud_client, provider, product, service)
        super cloud_client, provider, product, service
      end

      def setup
        storage_account_name = @product.settings[:az_custom_name]
        storage_account_key = @product.settings[:az_custom_key]
        storage_account_container = @product.settings[:az_custom_container]
        storage_account_blob = @product.settings[:az_custom_blob]

        client = Azure.client(storage_account_name: storage_account_name, storage_access_key: storage_account_key,
                              storage_blob_host: "https://#{storage_account_name}.blob.core.windows.net")
        _, content = client.blobs.get_blob storage_account_container, storage_account_blob

        @template = JellyfishAzure::Cloud::DeploymentTemplate.new content
      rescue Azure::Core::Http::HTTPError => e
        raise ValidationError, "There was a problem accessing the template: #{e.description}"
      end

      def template_url
        @template_url ||= begin
          storage_account_name = @product.settings[:az_custom_name]
          storage_account_key = @product.settings[:az_custom_key]
          storage_account_container = @product.settings[:az_custom_container]
          storage_account_blob = @product.settings[:az_custom_blob]

          container_uri = URI("https://#{storage_account_name}.blob.core.windows.net/#{storage_account_container}")

          signature = Azure::Blob::Auth::SharedAccessSignature.new storage_account_name, storage_account_key
          signed_uri = signature.signed_uri container_uri,
            permisions: :r,
            resource: :c,
            start: Time.now.utc.iso8601,
            expiry: (Time.now.utc + (30 * 60)).iso8601

          "#{container_uri}/#{storage_account_blob}?#{signed_uri.query}"
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
