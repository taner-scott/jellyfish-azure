require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe DatabaseProduct do
        mock = Jellyfish::Fog::Azure::Mock.new
        it 'returns an appropriate provisioner' do
          mock.mock!
          expect(DatabaseProduct.new.provisioner).to eq(Databases)
        end
      end
    end
  end
end
