require 'azure'
require 'open-uri'

module JellyfishAzure
  module Service
    class CustomPublicTemplate < AzureService
      def actions
        actions = super.merge :terminate

        # determine if action is available

        actions
      end

      def provision
        location = settings[:az_custom_location]
        template_uri = product.settings[:az_custom_template_uri]

        Delayed::Worker.logger.debug "Parameters"
        Delayed::Worker.logger.debug "location: #{location}"
        Delayed::Worker.logger.debug "template_uri: #{template_uri}"

        templateContent = open(template_uri).read
        template = DeploymentTemplate.new templateContent

        template_parameters = {
          templateBaseUrl: { value: URI::join(template_uri, ".").to_s },
          serviceName: { value: format_resource_name(uuid, name) }
        }

        template.parameters.each do |parameter|
          value = settings["az_custom_param_#{parameter.name}".to_sym]
          template_parameters[parameter.name] = { value: value } unless not value
        end

        # TODO: move the rest of the method to base class?
        ensure_resource_group location

        deploy_template 'Deployment', template_uri, template_parameters
        self.status = :provisioning
        save

        outputs = monitor_deployment 'Deployment'
        # TODO: handle writing status message and outputs to service
        self.status = :available
        outputs.each { |key, output| self.service_outputs.create(name: key, value: output, value_type: :string) }
        self.status_msg = "Deployment successful"
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
        self.status_msg = e.errors.map { |error| error.error_message }.join "\n"
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
        self.status_msg "Unexpected error: #{e.message}"
        save
      end

      def terminate
      end
    end
  end
end
