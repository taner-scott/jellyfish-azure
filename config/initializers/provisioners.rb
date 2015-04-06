require 'jellyfish_fog_azure/databases'
require 'jellyfish_fog_azure/infrastructure'
require 'jellyfish_fog_azure/storage'

Rails.application.config.x.provisioners.merge!(
  JSON.parse(File.read(Jellyfish::Fog::Azure::Engine.root.join('config', 'provisioners.json')))
    .map { |product_type, provisioner| [product_type, provisioner.constantize] }.to_h
)
