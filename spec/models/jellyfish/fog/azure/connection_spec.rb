require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe Connection do
        it 'returns a new connection' do
          expect(Connection.new.connect).to be_a_kind_of(::Fog::Compute::Azure::Mock)
        end
      end
    end
  end
end
