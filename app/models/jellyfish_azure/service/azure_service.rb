module JellyfishAzure
  module Service
    class AzureService < ::Service
      def service_initialize
      end

      def resource_group_name
        @_resource_group_name ||= begin
          safe_uuid = uuid.tr '-', ''
          safe_name = name.gsub(/[^0-9a-zA-Z_]/i, '')

          "jf#{safe_uuid}_#{safe_name}"
        end
      end

      def handle_error(message)
        self.status = :terminated
        self.status_msg = message
        save
      end

      def provision
        service_initialize

        ensure_resource_group location

        deploy_template 'Deployment', template_url, template_parameters

        outputs = monitor_deployment 'Deployment'

        self.status = :available
        outputs.each { |key, output| service_outputs.create(name: key, value: output, value_type: :string) }
        self.status_msg = 'Deployment successful'
        save

      rescue WaitUtil::TimeoutError
        handle_error 'The provisioning operation timed out.'
      rescue ValidationError => e
        handle_error "Validation error: #{e.message}"
      rescue AzureDeploymentErrors => e
        handle_error e.errors.map(&:error_message).join "\n"
      rescue MsRestAzure::AzureOperationError => e
        handle_azure_error e
      rescue => e
        Delayed::Worker.logger.error e.message
        Delayed::Worker.logger.error e.backtrace

        handle_error "Unexpected error: #{e.class}: #{e.message}"
      end

      private

      def client
        @_client ||= begin
          result = Azure::ARM::Resources::ResourceManagementClient.new product.provider.credentials
          result.subscription_id = product.provider.subscription_id
          result
        end
      end

      def ensure_resource_group(location)
        resource_group = Azure::ARM::Resources::Models::ResourceGroup.new
        resource_group.location = location

        promise = client.resource_groups.create_or_update(resource_group_name, resource_group)
        promise.value!

        resource_group_name
      end

      def deploy_template(deployment_name, template_url, template_parameters)
        logger.info "Starting '#{deployment_name}' in resource group '#{resource_group_name}'"

        properties = Azure::ARM::Resources::Models::DeploymentProperties.new
        properties.mode = 'Incremental'
        properties.parameters = template_parameters

        properties.template_link = Azure::ARM::Resources::Models::TemplateLink.new
        properties.template_link.uri = template_url

        params = Azure::ARM::Resources::Models::Deployment.new
        params.properties = properties

        promise = client.deployments.create_or_update(resource_group_name, deployment_name, params)
        promise.value!

        self.status = :provisioning
        save
      end

      def handle_azure_error(error)
        message = error.body.nil? ? error.message : error.body['error']['message']
        handle_error message
      end

      def monitor_deployment(deployment_name)
        result = nil
        WaitUtil.wait_for_condition 'deployment', timeout_sec: 14_400, delay_sec: 15 do
          promise = client.deployments.get resource_group_name, deployment_name
          result = promise.value!

          state = result.body.properties.provisioning_state
          (state != 'Accepted' && state != 'Running')
        end

        state = result.body.properties.provisioning_state
        if (state == 'Failed')
          promise = client.deployment_operations.list resource_group_name, deployment_name
          result = promise.value!

          fail AzureDeploymentErrors, result.body
        else
          outputs = result.body.properties.outputs || {}
          Hash[outputs.map { |key, value| [key, value['value']] }]
        end
      end
    end
  end
end
