require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe StorageProduct do
        let(:order_item) { double('order item', id: 1, uuid: 'u12345-c2579', answers: { location: 'East US' }) }
        let(:retire_order_item) { double('order item', id: 1, uuid: 'u12345-c2579', payload_response: { name: 'storageu12345c', location: 'East US' }) }
        ENV['AZURE_SUB_ID'] = 'abcdefg'
        ENV['AZURE_PEM_PATH'] = 'azure-cert.pem'
        ENV['AZURE_API_URL'] = 'https://management.core.windows.net'
        ::Fog.mock!
        it 'returns an appropriate provisioner' do
          expect(StorageProduct.new.provisioner).to eq(Storage)
        end
        it 'gets a connection' do
          if ::Fog.mock?
            expect(Storage.new(order_item).connection).to be_a_kind_of(::Fog::Compute::Azure::Mock)
          else
            expect(Storage.new(order_item).connection).to be_a_kind_of(::Fog::Compute::Azure::Real)
          end
        end

        it 'creates and retires a new storage account' do
          order_item.should_receive(:provision_status=).with(:ok)
          order_item.should_receive(:payload_response=).with a_kind_of(Hash)

          Storage.new(order_item).provision

          retire_order_item.should_receive(:provision_status=).with(:retired)

          Storage.new(retire_order_item).retire
        end
      end
    end
  end
end
