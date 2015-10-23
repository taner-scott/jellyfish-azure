require "rubygems"
require "json"
require 'open-uri'

module JellyfishAzure
  module Service
    class TemplateParameter
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

    class Template
      def initialize(file)
        @_data_hash = JSON.parse(file)
      end
      def parameters
        @_parameters ||= @_data_hash['parameters'].map {|key, value| TemplateParameter.new(key, value)}
      end
    end

    file = File.read('azuredeploy.json')
    #file = open("https://raw.githubusercontent.com/taner-scott/jellyfish-azure/master/templates/web-dev-environment/azuredeploy.json").read
    template = Template.new(file)
    #template.parameters.each { |value| puts "name: #{value.name} - type: #{value.type} - field: #{value.field} - options: #{value.allowed_value} - required: #{value.required}"}

    settings = {'az_custom_params_serviceName' => "one", 'az_custom_params_dnsNameForPublicIP' => "two", 'az_custom_params_webTechnology' => "three",
                'az_custom_params_dbTechnology' => "four", 'az_custom_params_adminUsername' => "five", 'az_custom_params_adminPassword' => "six",
                'az_custom_params_templateBaseUrl' => nil}
    parameters = {}
    template.parameters.each do |parameter|
      value = settings["az_custom_params_#{parameter.name}"]
      parameters[parameter.name] = {"value:" => value} unless not value
    end
    puts "settings: "
    puts settings
    puts "\n"
    puts "parameters: "
    puts parameters.to_json
    puts "\n"
  end
end
