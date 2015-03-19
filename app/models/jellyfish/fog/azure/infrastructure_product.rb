module Jellyfish
  module Fog
    module Azure
      class InfrastructureProduct < ActiveRecord::Base
        def provisioner
          Jellyfish::Fog::Azure::Infrastructure
        end
      end
    end
  end
end
