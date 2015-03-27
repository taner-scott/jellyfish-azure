module Jellyfish
  module Fog
    module Azure
      class StorageProductType
        DESCRIPTION = 'Storage'.freeze
        PRODUCT_CLASS = StorageProduct
        PRODUCT_QUESTIONS = JSON.parse(
          File.read(
             Jellyfish::Fog::AWS::Engine.root.join(
               *%w(config product_questions storage.json)
             )
          )
        )
      end
    end
  end
end