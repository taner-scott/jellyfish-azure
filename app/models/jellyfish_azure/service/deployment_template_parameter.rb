module JellyfishAzure
  module Service
    class DeploymentTemplateParameter
      TYPE_HASH = {
        'string' => :string,
        'securestring' => :string,
        'int' => :integer,
        'bool' => :boolean
      }

      FIELD_HASH = {
        'string' => :text,
        'securestring' => :password,
        'int' => :az_integer,
        'bool' => :checkbox
      }

      attr_reader :name, :type, :default_value, :allowed_value, :field, :required

      def initialize(key, values)
        @name = key
        @type = TYPE_HASH[values['type']]
        @default_value = values['defaultValue']
        @allowed_value = values['allowedValues']

        if !@allowed_value.nil?
          @field = :az_choice
        else
          @field = FIELD_HASH[values['type']]
        end

        @required = @default_value.nil?
      end
    end
  end
end
