require 'spec_helper'

module Jellyfish
  module Fog
    module Azure
      describe InfrastructureProduct do
        let(:order_item) { double('order item', id: 1, answers: { vm_name: 'test_name', vm_user: 'admin', image: '0b11de9248dd4d87b18621318e037d37__RightImage-CentOS-6.2-x64-v5.8.8.1', location: 'East Asia', cloud_service_name: 'testjellyfish', certificate_file: 'azure-cert.cer', private_key_file: 'azure-cert.pem' }) }
        let(:retire_order_item) { double('order item', id: 1, payload_response: { vm_name: 'test_name', vm_user: 'admin', image: '0b11de9248dd4d87b18621318e037d37__RightImage-CentOS-6.2-x64-v5.8.8.1', location: 'East Asia', cloud_service_name: 'testjellyfish' }) }
        ENV['JF_AZURE_SUB_ID'] = 'abcdefg'
        ENV['JF_AZURE_PEM_PATH'] = 'azure-cert.pem'
        ENV['JF_AZURE_API_URL'] = 'https://management.core.windows.net'
        mock = Jellyfish::Fog::Azure::Mock.new
        it 'returns an appropriate provisioner' do
          expect(InfrastructureProduct.new.provisioner).to eq(Infrastructure)
        end

        it 'gets a connection' do
          mock.mock!
          expect(Infrastructure.new(order_item).connection).to be_a_kind_of(::Fog::Compute::Azure::Mock)
        end

        it 'provisions and destroys a new server' do
          mock.mock!
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
