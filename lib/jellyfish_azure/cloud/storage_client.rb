module JellyfishAzure
  module Cloud
    class StorageClient
      def initialize(credentials, subscription_id)
        @client = ::Azure::ARM::Storage::StorageManagementClient.new credentials
        @client.subscription_id = subscription_id
      end

      def get_blob_sas_uri(storage_account_name, storage_account_key, storage_account_container, storage_account_blob, timeout_minutes)
        container_uri = URI("https://#{storage_account_name}.blob.core.windows.net/#{storage_account_container}")

        signature = Azure::Blob::Auth::SharedAccessSignature.new storage_account_name, storage_account_key
        signed_uri = signature.signed_uri container_uri,
          permisions: :r,
          resource: :c,
          start: Time.now.utc.iso8601,
          expiry: (Time.now.utc + (timeout_minutes * 60)).iso8601

        "#{container_uri}/#{storage_account_blob}?#{signed_uri.query}"
      end

      def get_blob(storage_account_name, storage_account_key, storage_account_container, storage_account_blob)
        client = Azure.client(storage_account_name: storage_account_name, storage_access_key: storage_account_key,
                              storage_blob_host: "https://#{storage_account_name}.blob.core.windows.net")
        _, content = client.blobs.get_blob storage_account_container, storage_account_blob

        content
      rescue Faraday::ConnectionFailed => _
        # logger.debug e.message

        raise CloudArgumentError.new 'Name or service not known', :storage_account_name
      rescue Azure::Core::Http::HTTPError => e
        # logger.debug e.message

        raise convert_azure_http_error e
      rescue ArgumentError => e
        # logger.debug e.message

        raise convert_blob_argument_error e
      end

      def check_name_availability(name)
        parameters = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
        parameters.name = name
        parameters.type = 'Microsoft.Storage/storageAccounts'

        promise = @client.storage_accounts.check_name_availability parameters
        result = promise.value!

        [result.body.name_available, result.body.message]
      end

      private

      def convert_azure_http_error(e)
        case e.type
        when 'BlobNotFound'
          CloudArgumentError.new 'The specified file does not exist', :storage_account_blob
        when 'ContainerNotFound'
          CloudArgumentError.new 'The specified container does not exist', :storage_account_container
        when 'AuthenticationFailed'
          CloudArgumentError.new 'The storage account key is invalid', :storage_account_key
        else
          CloudArgumentError.new 'Unknown error'
        end
      end

      def convert_blob_argument_error(e)
        case e.message
        when 'invalid base64'
          CloudArgumentError.new 'Invalid base64 value', :storage_account_key
        else
          CloudArgumentError.new 'Unknown error'
        end
      end
    end
  end
end
