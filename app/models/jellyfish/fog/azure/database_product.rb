module Jellyfish
  module Fog
    module Azure
      class DatabaseProduct < ActiveRecord::Base
        def provisioner
          Jellyfish::Fog::Azure::Databases
        end
      end
    end
  end
end
