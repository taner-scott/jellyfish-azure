module JellyfishAzure
  module Service
    class DeploymentTemplateParameter
      @field_hash = {
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
          @field = @field_hash[@type.downcase]
        end

        @required = @default_value.nil?
      end
    end
  end
end
