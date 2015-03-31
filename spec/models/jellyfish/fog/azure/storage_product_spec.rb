require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe StorageProduct do
        let(:order_item) { double('order item', id: 1, uuid: 'u12345-c2579', answers: { location: 'East US' }) }
        let(:retire_order_item) { double('retire order item', id: 1, uuid: 'u12345-c2579', payload_response: { name: 'storageu12345c', location: 'East US' }) }
        ENV['JF_AZURE_SUB_ID'] = 'abcdefg'
        ENV['JF_AZURE_PEM_PATH'] = 'azure-cert.pem'
        ENV['JF_AZURE_API_URL'] = 'https://management.core.windows.net'
        mock = Jellyfish::Fog::Azure::Mock.new
        it 'returns an appropriate provisioner' do
          mock.mock!
          expect(StorageProduct.new.provisioner).to eq(Storage)
        end

        it 'gets a connection' do
          mock.mock!
          expect(Storage.new(order_item).connection).to be_a_kind_of(::Fog::Compute::Azure::Mock)
        end

        it 'creates and retires a new storage account' do
          mock.mock!
          expect(order_item).to receive(:provision_status=).with(:ok)
          expect(order_item).to receive(:payload_response=).with a_kind_of(Hash)

          Storage.new(order_item).provision

          expect(retire_order_item).to receive(:provision_status=).with(:retired)

          Storage.new(retire_order_item).retire
        end
      end
    end
  end
end
