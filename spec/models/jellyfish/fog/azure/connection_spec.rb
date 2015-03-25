require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe Connection do
        mock = Jellyfish::Fog::Azure::Mock.new
        it 'returns a new connection' do
          mock.mock!
          expect(Connection.new.connect).to be_a_kind_of(::Fog::Compute::Azure::Mock)
        end
      end
    end
  end
end
