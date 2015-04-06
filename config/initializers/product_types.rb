[
  Jellyfish::Fog::Azure::DatabaseProductType,
  Jellyfish::Fog::Azure::StorageProductType,
  Jellyfish::Fog::Azure::InfrastructureProductType
].each do |type|
  Rails.configuration.x.product_types.merge!(type.as_json)
end
