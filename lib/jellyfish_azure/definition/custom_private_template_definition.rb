module JellyfishAzure
  module Definition
    class CustomPrivateTemplateDefinition
      EXCLUDE_PARAMS = %w(templateBaseUrl sasToken serviceName)

      def self.product_questions
        [
          { label: 'Storage Account Name', name: :az_custom_name, value_type: :string, field: :text, required: true },
          { label: 'Storage Account Key', name: :az_custom_key, value_type: :string, field: :password, required: true },
          { label: 'Storage Account Container', name: :az_custom_container, value_type: :string, field: :text, required: true },
          { label: 'Storage Account Blob', name: :az_custom_blob, value_type: :string, field: :text, required: true }
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
        content = @cloud_client.storage.get_blob(
          @product.settings[:az_custom_name],
          @product.settings[:az_custom_key],
          @product.settings[:az_custom_container],
          @product.settings[:az_custom_blob])

        # parse the template
        JellyfishAzure::DeploymentTemplate.new content
      rescue JellyfishAzure::Cloud::CloudArgumentError => e
        raise ValidationError.new e.message, convert_blob_argument(e.field)
      rescue JSON::ParserError => _
        # logger.debug e.message

        raise ValidationError.new 'There was a problem parsing the template', :az_custom_blob
      end

      def convert_blob_argument(argument)
        case argument
        when :storage_account_name
          :az_custom_name
        when :storage_account_key
          :az_custom_key
        when :storage_account_container
          :az_custom_container
        when :storage_account_blob
          :az_custom_blob
        end
      end
    end
  end
end
