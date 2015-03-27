require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe Validation do
        ENV['JF_AZURE_SUB_ID'] = 'fake'
        ENV['JF_AZURE_PEM_PATH'] = 'fake.pem'
        ENV['JF_AZURE_API_URL'] = 'https://management.core.windows.net'
        mock = Jellyfish::Fog::Azure::Mock.new

        it 'returns a false value for invalid credentials' do
          mock.unmock!
          validated = Validation.new.validate
          expect(validated).to eq(false)
        end
      end
    end
  end
end
