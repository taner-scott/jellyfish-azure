require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe DatabaseProduct do
        mock = Jellyfish::Fog::Azure::Mock.new
        let(:order_item) { double('order item', id: 1, answers: { location: 'East Asia' }) }
        let(:retire_order_item) { double('order item', id: 1, payload_response: { name: 'name' }) }
        it 'returns an appropriate provisioner' do
          mock.mock!
          expect(DatabaseProduct.new.provisioner).to eq(Databases)
        end

        it 'creates a new database server' do
          mock.mock!
          expect(order_item).to receive(:provision_status=).with(:ok)
          expect(order_item).to receive(:payload_response=).with a_kind_of(Hash)

          Databases.new(order_item).provision
        end

        it 'retires a server' do
          mock.mock!
          expect(retire_order_item).to receive(:provision_status=).with(:retired)

          Databases.new(retire_order_item).retire
        end
      end
    end
  end
end
