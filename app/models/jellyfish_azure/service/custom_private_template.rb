require 'azure'
require 'azure/blob/auth/shared_access_signature'

module JellyfishAzure
  module Service
    class CustomPrivateTemplate < AzureService
      def actions
        actions = super.merge :terminate

        # determine if action is available

        actions
      end

      def validate_blob(storage_account_name, storage_account_key, container, blob)
        client = Azure.client(storage_account_name: storage_account_name, storage_access_key: storage_account_key,
                              storage_blob_host: 'https://jellyfishprivate.blob.core.windows.nets')
        client.blobs.get_blob_properties container, blob
        true
      rescue
        false
      end

      def provision
        location = settings[:az_custom_location]
        storage_account_name = product.settings[:az_custom_name]
        storage_account_key = product.settings[:az_custom_key]
        storage_account_container = product.settings[:az_custom_container]
        storage_account_blob = product.settings[:az_custom_blob]

        # validate the storage account blob
        valid_blob = validate_blob storage_account_name, storage_account_key, storage_account_container, storage_account_blob
        unless valid_blob
          self.status = :terminated
          self.status_msg = 'The storage account connection information is invalid.'
          save

          return
        end

        container_uri = URI("https://#{storage_account_name}.blob.core.windows.net/#{storage_account_container}")

        signature = Azure::Blob::Auth::SharedAccessSignature.new storage_account_name, storage_account_key
        signed_uri = signature.signed_uri container_uri,
          permisions: :r,
          resource: :c,
          start: Time.now.utc.iso8601,
          expiry: (Time.now.utc + (30 * 60)).iso8601

        blob_uri = "#{container_uri}/#{storage_account_blob}?#{signed_uri.query}"

        # TODO: download the template and parse the parameters

        # TODO: make this generic
        template_parameters = {
          templateBaseUrl: { value: URI.join(blob_uri, '.').to_s },
          sasToken: { value: URI(blob_uri).query },
          serviceName: { value: format_resource_name(uuid, name) },

          dnsNameForPublicIP: { value: settings[:az_custom_param_dnsNameForPublicIP] },
          adminUsername: { value: settings[:az_custom_param_adminUsername] },
          adminPassword: { value: settings[:az_custom_param_adminPassword] }
        }

        # TODO: move the rest of the method to base class?
        ensure_resource_group location

        deploy_template 'Deployment', blob_uri, template_parameters
        self.status = :provisioning
        save

        outputs = monitor_deployment 'Deployment'
        # TODO: handle writing status message and outputs to service
        self.status = :available
        outputs.each { |key, output| service_outputs.create(name: key, value: output, value_type: :string) }
        self.status_msg = 'Deployment successful'
        save

      rescue WaitUtil::TimeoutError => e
        Delayed::Worker.logger.error e.message

        self.status = :terminated
        self.status_msg = 'The provisioning operation timed out.'
        save
      rescue AzureDeploymentErrors => e
        Delayed::Worker.logger.error e.message
        Delayed::Worker.logger.error e.backtrace

        self.status = :terminated
        self.status_msg = e.errors.map(&:error_message).join '\n'
        save
      rescue MsRestAzure::AzureOperationError => e
        Delayed::Worker.logger.error e.message
        Delayed::Worker.logger.error e.backtrace

        self.status = :terminated

        if e.body.nil?
          self.status_msg = e.message
        else
          self.status_msg = e.body['error']['message']
        end

        save
      rescue => e
        Delayed::Worker.logger.error e.message
        Delayed::Worker.logger.error e.backtrace

        self.status = :terminated
        status_msg "Unexpected error: #{e.message}"
        save
      end

      def terminate
      end
    end
  end
end
