module Jellyfish
  module Fog
    module Azure
      class Mock
        def mock!
          ::Fog.mock!
        end

        def unmock!
          ::Fog.unmock!
        end

        def mock?
          ::Fog.mock?
        end
      end
    end
  end
end
