require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe DatabaseProduct do
        mock = Jellyfish::Fog::Azure::Mock.new
        let(:order_item) { double('order item', id: 1, answers: { location: 'East Asia' }) }
        it 'returns an appropriate provisioner' do
          mock.mock!
          expect(DatabaseProduct.new.provisioner).to eq(Databases)
        end

        it 'creates a new database server' do
          mock.mock!
          order_item.should_receive(:provision_status=).with(:ok)
          order_item.should_receive(:payload_response=).with a_kind_of(Hash)
          Databases.new(order_item).provision
        end
      end
    end
  end
end
