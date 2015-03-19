require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe DatabaseProduct do
        it 'returns an appropriate provisioner' do
          expect(DatabaseProduct.new.provisioner).to eq(Databases)
        end
      end
    end
  end
end
