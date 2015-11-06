
module JellyfishAzure
  module Operation
    class AzureProvisionOperation
      DEPLOYMENT_NAME = 'Deployment'
      WAIT_TIMEOUT = 14_400
      WAIT_DELAY = 15

      attr_accessor :deploy_timeout, :deploy_delay

      def initialize(cloud_client, provider, product, service)
        @cloud_client = cloud_client
        @provider = provider
        @product = product
        @service = service

        @deploy_timeout = WAIT_TIMEOUT
        @deploy_delay = WAIT_DELAY
      end

      def setup
      end

      def location
      end

      def template_url
      end

      def template_parameters
      end

      def resource_group_name
        @_resource_group_name ||= begin
          safe_uuid = @service.uuid.tr '-', ''
          safe_name = @service.name.gsub(/[^0-9a-zA-Z_]/i, '')

          "jf#{safe_uuid}_#{safe_name}"
        end
      end

      def execute
        setup

        @cloud_client.resource_group.create_resource_group resource_group_name, location

        @cloud_client.deployment.create_deployment resource_group_name, DEPLOYMENT_NAME, template_url, template_parameters

        set_status :provisioning, 'Provisioning service'

        outputs = wait_for_deployment DEPLOYMENT_NAME

        outputs.each { |key, value| @service.service_outputs.create(name: key, value: value[:value], value_type: :string) }

        set_status :available, 'Deployment successful'

      rescue WaitUtil::TimeoutError
        handle_error 'The provisioning operation timed out.'
      rescue ValidationError => e
        handle_error e.to_s
      rescue AzureDeploymentErrors => e
        handle_error e.errors.map(&:error_message).join "\n"
      rescue MsRestAzure::AzureOperationError => e
        handle_azure_error e
      rescue => e
        handle_error "Unexpected error: #{e.class}: #{e.message}"
      end

      protected

      def set_status(status, message)
        @service.status = status
        @service.status_msg = message
        @service.save
      end

      def handle_error(message)
        set_status :terminated, message
      end

      def handle_azure_error(error)
        message = error.body.nil? ? error.message : error.body['error']['message']
        set_status :terminated, message
      end

      private

      def wait_for_deployment(deployment_name)
        state = nil
        outputs = nil
        WaitUtil.wait_for_condition 'deployment', timeout_sec: deploy_timeout, delay_sec: deploy_delay do
          state, outputs = @cloud_client.deployment.get_deployment_status resource_group_name, deployment_name

          (state != 'Accepted' && state != 'Running')
        end

        if (state == 'Failed')
          errors = @cloud_client.deployment.get_deployment_errors resource_group_name, deployment_name

          fail AzureDeploymentErrors, errors
        end

        outputs
      end
    end
  end
end
