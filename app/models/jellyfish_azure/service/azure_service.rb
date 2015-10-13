module JellyfishAzure
  module Service
    class AzureService < ::Service::Storage
      def client
        @_client ||= begin
          result = Azure::ARM::Resources::ResourceManagementClient.new product.provider.credentials
          result.subscription_id = product.provider.subscription_id
          result
        end
      end

      def resource_group_name
        @_resource_group_name ||= begin
          short_uuid = uuid.tr '-', ''
          ("jf#{short_uuid}_#{name}")[0...85]
        end
      end

      def ensure_resource_group location
        resource_group = Azure::ARM::Resources::Models::ResourceGroup.new()
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

        # TODO: replace this with the template url once it's working well
        # properties.template = JSON.parse(File.read(template_url));
        properties.template_link = Azure::ARM::Resources::Models::TemplateLink.new()
        properties.template_link.uri = template_url

        params = Azure::ARM::Resources::Models::Deployment.new
        params.properties = properties;

        promise = client.deployments.create_or_update(resource_group_name, deployment_name, params);
        promise.value!
      end

      def monitor_deployment(deployment_name)
        result = nil
        WaitUtil.wait_for_condition 'deployment', :timeout_sec => 14400, :delay_sec => 15 do
          promise = client.deployments.get resource_group_name, deployment_name
          result = promise.value!

          state = result.body.properties.provisioning_state
          (state != "Accepted" and state != "Running")
        end

        state = result.body.properties.provisioning_state
        if (state == 'Failed')
          promise = client.deployment_operations.list resource_group_name, deployment_name
          result = promise.value!

          raise AzureDeploymentErrors.new(result.body)
        else
          Hash[result.body.properties.outputs.map { |key, value| [ key, value['value'] ] }]
        end
      end
    end
  end
end
