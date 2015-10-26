module JellyfishAzure
  module Service
    class DeploymentTemplateParameter
      def initialize(key, values)
        @name = key
        @type = values['type']
        @default_value = values['defaultValue']
        @allowed_value = values['allowedValues']

        field_hash = {"string" => "text", "securestring" => "password", "int" => "integer"}
        if !@allowed_value.nil?
          @field = "choice"
        else
          @field = field_hash[@type.downcase]
        end

        @required = @default_value.nil?

      end
      attr_reader :name, :type, :default_value, :allowed_value, :field, :required
    end
  end
end
