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
      rescue Faraday::ConnectionFailed => _
        # logger.debug e.message

        raise ValidationError.new 'Name or service not known', :az_custom_name
      rescue Azure::Core::Http::HTTPError => e
        # logger.debug e.message

        case e.type
        when 'BlobNotFound'
          raise ValidationError.new 'The specified file does not exist', :az_custom_blob
        when 'ContainerNotFound'
          raise ValidationError.new 'The specified container does not exist', :az_custom_container
        when 'AuthenticationFailed'
          raise ValidationError.new 'The storage account key is invalid', :az_custom_key
        else
          raise ValidationError, 'Unknown error'
        end
      rescue JSON::ParserError => _
        # logger.debug e.message

        raise ValidationError.new 'There was a problem parsing the template', :az_custom_blob
      rescue ArgumentError => e
        # logger.debug e.message
        case e.message
        when 'invalid base64'
          raise ValidationError.new 'Invalid base64 value', :az_custom_key
        else
          raise ValidationError, 'Unknown error'
        end
      end
    end
  end
end
