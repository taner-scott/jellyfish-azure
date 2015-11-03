module JellyfishAzure
  module Cloud
    class DeploymentTemplate
      def initialize(file)
        @_data_hash = JSON.parse(file)
      end

      def parameters
        params = @_data_hash['parameters'] || {}
        @_parameters ||= params.map { |key, value| DeploymentTemplateParameter.new(key, value) }
      end

      def find_allowed_values(parameter_name)
        parameter_name = parameter_name[16..-1]

        param = parameters.find { |parameter| parameter.name == parameter_name }

        param.nil? ? param : param.allowed_value
      end

      def apply_parameters(prefix, values)
        result = {}

        parameters.each do |parameter|
          value = values[(prefix + parameter.name).to_sym]

          # handle the case where no value is provided for boolean parameters
          value = false if value.nil? && parameter.type == :boolean

          result[parameter.name] = { value: value } unless value.nil?
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
