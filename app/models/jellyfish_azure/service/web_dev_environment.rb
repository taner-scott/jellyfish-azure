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
        self.status = :available
        save

        # TODO: handle writing status message and outputs to service
        puts outputs.to_json
        outputs

      rescue MsRestAzure::AzureOperationError => e
        self.status = :available
        save

        puts e.body.to_json
        puts e.backtrace.join("\n")
        raise
      rescue => e
        self.status = :available
        save

        puts e.message
        puts e.backtrace.join("\n")
        raise
      end

      def terminate
      end
    end
  end
end
