$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jellyfish_fog_azure/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jellyfish-azure"
  s.version     = Jellyfish::Fog::Azure::VERSION
  s.authors     = ["Jillian Tullo"]
  s.email       = ["tullo_jillian@bah.com"]
  s.homepage    = "https://github.com/projectjellyfish/jellyfish-azure"
  s.summary     = "Azure Module for Jellyfish"
  s.description = "Adds Microsoft Azure provisioning support to Jellyfish"
  s.license     = "APACHE"
  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.add_dependency 'dotenv-rails'
  s.add_dependency 'rails'
end
