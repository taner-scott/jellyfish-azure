module JellyfishAzure
  module Service
    class WebDevEnvironment < AzureService
      def actions
        actions = super.merge :terminate

        # determine if action is available

        actions
      end

      def provision
        ensure_resource_group 'westus'

        template_url = File.expand_path('../../../../../templates/web-dev-environment/smalldeploy.json', __FILE__);
        template_parameters = {
          projectName: { value: 'jf_' + project.name },
          serviceName: { value: 'jf' + uuid.tr('-','') + '_' + name },
          webTechnology: { value: product.settings[:az_dev_web] },
          dbTechnology: { value: product.settings[:az_dev_db] },
          dnsNameForPublicIP: { value: settings[:az_dev_dns] },
          adminUsername: { value: settings[:az_username] },
          adminPassword: { value: settings[:az_password] }
        }

        deploy_template 'Deployment', template_url, template_parameters
        self.status = :provisioning
        save

        outputs = monitor_deployment 'Deployment'

        # TODO: handle writing status message and outputs to service
        self.status = :available
        self.status_msg = outputs.to_json
        save

        outputs

      rescue WaitUtil::TimeoutError => e
        self.status = :terminated
        self.status_msg = 'The provisioning operation timed out.'
        save
      rescue AzureDeploymentErrors => e
        self.status = :terminated
        self.status_msg = e.errors.map { |error| error.error_message }.join "\n"
        save
      rescue MsRestAzure::AzureOperationError => e
        self.status = :terminated

        if e.body.nil?
          self.status_msg = e.message
        else
          self.status_msg = e.body['error']['message']
        end
        save
      rescue => e
        self.status = :terminated
        self.status_msg "Unexpected error: #{e.message}"
        save
      end

      def terminate
      end
    end
  end
end
