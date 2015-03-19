$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jellyfish_fog_azure/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jellyfish_fog_azure"
  s.version     = Jellyfish::Fog::Azure::VERSION
  s.authors     = ["Jillian Tullo"]
  s.email       = ["tullo_jillian@bah.com"]
  s.homepage    = "https://github.com/projectjellyfish/jellyfish-azure"
  s.summary     = "Azure Module for Jellyfish"
  s.description = "Adds Microsoft Azure provisioning support to Jellyfish"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"
  s.add_dependency "rspec-rails", "~> 2.14.1"

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'pry-rails'
end
