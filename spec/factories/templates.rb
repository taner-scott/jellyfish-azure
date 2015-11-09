require 'pathname'

module JellyfishAzure
  module Factories
    def self.template_root
      Pathname('../templates').expand_path(__FILE__)
    end

    def arm_template_file(name)
      path = JellyfishAzure::Factories.template_root.join("#{name}.json")
      File.open(path)
    end

    def arm_template_json(name)
      arm_template_file(name).read
    end

    def arm_template(name)
      JellyfishAzure::DeploymentTemplate.new arm_template_json(name)
    end
  end
end
