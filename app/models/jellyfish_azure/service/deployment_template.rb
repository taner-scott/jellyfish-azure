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

      def get_questions(prefix, exclude_list)
          parameters
            .reject { |parameter| exclude_list.include? parameter.name }
            .map do |parameter|
              {
                label: parameter.name,
                name: prefix + parameter.name,
                value_type: parameter.type,
                field: parameter.field,
                required: parameter.type
              }
            end
      end
    end
  end
end
