module JellyfishAzure
  class DeploymentTemplateParameter
    TYPE_HASH = {
      'string' => :string,
      'securestring' => :string,
      'int' => :integer,
      'bool' => :boolean,
      'object' => :json,
      'secureobject' => :json,
      'array' => :json
    }

    FIELD_HASH = {
      'string' => :text,
      'securestring' => :password,
      'int' => :az_integer,
      'bool' => :checkbox,
      'object' => :textarea,
      'secureobject' => :textarea,
      'array' => :textarea
    }

    attr_reader :name, :type, :default_value, :allowed_value, :field, :required

    def initialize(key, values)
      @name = key
      @type = TYPE_HASH[values['type'].downcase]
      @default_value = values['defaultValue']
      @allowed_value = values['allowedValues']

      if !@allowed_value.nil?
        @field = :az_choice
      else
        @field = FIELD_HASH[values['type'].downcase]
      end

      @required = @default_value.nil?
    end
  end
end
