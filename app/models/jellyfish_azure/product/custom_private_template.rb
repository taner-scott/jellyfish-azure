require 'azure'

module JellyfishAzure
  module Product
    class CustomPrivateTemplate < ::Product
      def order_questions
        @_order_questions ||= begin
          storage_account_name = settings[:az_custom_name]
          storage_account_key = settings[:az_custom_key]
          storage_account_container = settings[:az_custom_container]
          storage_account_blob = settings[:az_custom_blob]

          client = Azure.client(storage_account_name: storage_account_name, storage_access_key: storage_account_key,
                                storage_blob_host: "https://#{storage_account_name}.blob.core.windows.net")
          _, content = client.blobs.get_blob storage_account_container, storage_account_blob

          @template = JellyfishAzure::Service::DeploymentTemplate.new content

          default_questions = [
            { label: 'Location', name: :az_custom_location, value_type: :string, field: :az_custom_location, required: true }
          ]

          template_questions = @template.get_questions 'az_custom_param_', ["templateBaseUrl", "sasToken", 'serviceName']

          default_questions + template_questions
        end
      end

      def service_class
        'JellyfishAzure::Service::CustomPrivateTemplate'.constantize
      end
    end
  end
end

