require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe Validation do
        ENV['JF_AZURE_SUB_ID'] = 'fake'
        ENV['JF_AZURE_PEM_PATH'] = 'azure-cert.pem'
        ENV['JF_AZURE_API_URL'] = 'https://management.core.windows.net'
        mock = Jellyfish::Fog::Azure::Mock.new

        it 'returns a false true for valid credentials' do
          mock.mock!
          validated = Validation.new.validate
          expect(validated).to eq(true)
        end
      end
    end
  end
end
