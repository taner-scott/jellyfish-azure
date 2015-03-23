module Jellyfish
  module Fog
    module Azure
      class Engine < ::Rails::Engine
        isolate_namespace Jellyfish::Fog::Azure
        config.generators do |g|
          g.test_framework :rspec
        end
      end
    end
  end
end
