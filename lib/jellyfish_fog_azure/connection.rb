module Jellyfish
  module Fog
    module Azure
      class Connection
        def connect
          ::Fog::Compute.new(
            provider: 'Azure',
            azure_sub_id: ENV['AZURE_SUB_ID'],
            azure_pem: ENV['AZURE_PEM_PATH'],
            azure_api_url: ENV['AZURE_API_URL']
          )
        end
      end
    end
  end
end
