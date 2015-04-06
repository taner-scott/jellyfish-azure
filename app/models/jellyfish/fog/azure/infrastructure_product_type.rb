module Jellyfish
  module Fog
    module Azure
      class InfrastructureProductType
        DESCRIPTION = 'Infrastructure'.freeze
        PRODUCT_CLASS = InfrastructureProduct
        PRODUCT_QUESTIONS = JSON.parse(
          File.read(
            Jellyfish::Fog::Azure::Engine.root.join(
              *%w(config product_questions infrastructure.json)
            )
          )
        ).freeze

        def self.description
          DESCRIPTION
        end

        def self.product_questions
          PRODUCT_QUESTIONS
        end

        def self.as_json(*)
          { DESCRIPTION => PRODUCT_QUESTIONS }
        end
      end
    end
  end
end