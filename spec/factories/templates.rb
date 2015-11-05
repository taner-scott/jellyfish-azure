require 'pathname'

module JellyfishAzure
  module Factories
    def self.template_root
      Pathname('../templates').expand_path(__FILE__)
    end

    def self.template_file(name)
      path = template_root.join("#{name.to_s}.json")
      File.open(path)
    end

    def self.template(name)
      template_json = template_file(name).read
      JellyfishAzure::Cloud::DeploymentTemplate.new template_json
    end
  end
end

