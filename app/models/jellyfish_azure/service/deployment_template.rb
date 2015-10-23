module JellyfishAzure
  module Service
    class DeploymentTemplate
      def initialize(file)
        @_data_hash = JSON.parse(file)
      end
      def parameters
        @_parameters ||= @_data_hash['parameters'].map {|key, value| DeploymentTemplateParameter.new(key, value)}
      end
    end
  end
end
