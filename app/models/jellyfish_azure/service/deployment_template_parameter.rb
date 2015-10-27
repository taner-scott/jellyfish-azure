module JellyfishAzure
  module Service
    class DeploymentTemplateParameter
      FIELD_HASH = {
        'string' => 'text',
        'securestring' => 'password',
        'int' => 'integer'
      }

      attr_reader :name, :type, :default_value, :allowed_value, :field, :required

      def initialize(key, values)
        @name = key
        @type = values['type']
        @default_value = values['defaultValue']
        @allowed_value = values['allowedValues']

        if !@allowed_value.nil?
          @field = 'choice'
        else
          @field = FIELD_HASH[@type.downcase]
        end

        @required = @default_value.nil?
      end
    end
  end
end
