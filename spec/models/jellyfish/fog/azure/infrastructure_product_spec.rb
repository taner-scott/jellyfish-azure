require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe InfrastructureProduct do
        let(:order_item) { double('order item', id: 1, answers: { vm_name: 'test_name', vm_user: 'admin', image: 'abcd', location: 'East Asia', cloud_service_name: 'testjellyfish', certificate_file: 'azure-cert.cer', private_key_file: 'azure-cert.pem' }) }
        let(:retire_order_item) { double('order item', id: 1, payload_response: { vm_name: 'test_name', vm_user: 'admin', image: 'abcd', location: 'East Asia', cloud_service_name: 'testjellyfish' }) }
        ENV['AZURE_SUB_ID'] = 'abcdefg'
        ENV['AZURE_PEM_PATH'] = 'azure-cert.pem'
        ENV['AZURE_API_URL'] = 'https://management.core.windows.net'
        ::Fog.mock!
        it 'returns an appropriate provisioner' do
          expect(InfrastructureProduct.new.provisioner).to eq(Infrastructure)
        end

        it 'gets a connection' do
          if ::Fog.mock?
            expect(Infrastructure.new(order_item).connection).to be_a_kind_of(::Fog::Compute::Azure::Mock)
          else
            expect(Infrastructure.new(order_item).connection).to be_a_kind_of(::Fog::Compute::Azure::Real)
          end
        end

        it 'provisions and destroys a new server' do
          order_item.should_receive(:provision_status=).with(:ok)
          order_item.should_receive(:payload_response=).with a_kind_of(Hash)
          Infrastructure.new(order_item).provision

          retire_order_item.should_receive(:provision_status=).with(:retired)
          Infrastructure.new(retire_order_item).retire
        end
      end
    end
  end
end
