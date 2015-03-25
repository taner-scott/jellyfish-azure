require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe Validation do
        ENV['JF_AZURE_SUB_ID'] = 'abcdefg'
        ENV['JF_AZURE_PEM_PATH'] = 'fake.pem'
        ENV['JF_AZURE_API_URL'] = 'https://management.core.windows.net'

        it 'returns a true value for valid credentials' do
          ::Fog.mock!
          validated = Validation.new.validate
          expect(validated).to eq(true)
        end

        it 'returns a false value for invalid credentials' do
          ::Fog.unmock!
          validated = Validation.new.validate
          expect(validated).to eq(false)
        end
      end
    end
  end
end
