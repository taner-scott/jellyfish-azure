require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe Mock do
        it 'should set mock to true' do
          mock = Jellyfish::Fog::Azure::Mock.new
          mock.mock!
          expect(::Fog.mock?).to eq(true)
        end

        it 'should set mock to false' do
          mock = Jellyfish::Fog::Azure::Mock.new
          mock.unmock!
          expect(::Fog.mock?).to eq(false)
        end

        it 'should get a value for mock' do
          mock = Jellyfish::Fog::Azure::Mock.new
          mock.mock?
          expect(::Fog.mock?).to eq(true) || eq(false)
        end
      end
    end
  end
end
