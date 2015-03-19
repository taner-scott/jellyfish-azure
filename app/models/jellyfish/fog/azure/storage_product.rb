module Jellyfish
  module Fog
    module Azure
      class StorageProduct < ActiveRecord::Base
        def provisioner
          Jellyfish::Fog::Azure::Storage
        end
      end
    end
  end
end
