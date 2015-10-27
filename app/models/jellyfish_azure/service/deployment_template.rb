module JellyfishAzure
  module Service
    class DeploymentTemplate
      def initialize(file)
        @_data_hash = JSON.parse(file)
      end

      def parameters
        @_parameters ||= @_data_hash['parameters'].map { |key, value| DeploymentTemplateParameter.new(key, value) }
      end

      def apply_parameters(prefix, values)
        result = {}

        parameters.each do |parameter|
          value = values[(prefix + parameter.name).to_sym]
          result[parameter.name] = { value: value } if value
        end

        result
      end
    end
  end
end
