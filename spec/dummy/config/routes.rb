Rails.application.routes.draw do

  mount Jellyfish::Fog::Azure::Engine => "/jellyfish_fog_azure"
end
