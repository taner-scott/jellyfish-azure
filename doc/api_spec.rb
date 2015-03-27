# This is the file that will be copied to the
# /spec/modules directory within API upon initialization
# of the gem
require 'rails_helper'

def find_gem(name)
  Gem::Specification.find_by_name(name)
  true
rescue Gem::LoadError
  false
end

def infrastructure_order_item
  @order_item ||= OpenStruct.new.tap do |order_item|
    order_item.uuid = '1234567890'
    order_item.answers = {
      'vm_name' => 'jellyfish_vm',
      'vm_user' => 'admin',
      'image' => 'the_image',
      'location' => 'East Asia',
      'cloud_service_name' => 'testjellyfish',
      'certificate_file' => 'azure-cert.cer',
      'private_key_file' => 'azure-cert.pem'
    }
  end
end

def storage_order_item
  @order_item ||= OpenStruct.new.tap do |order_item|
    order_item.uuid = '1234567890'
    order_item.id = 1
    order_item.answers = {
      'location' => 'East Asia'
    }
  end
end

def azure_settings
  create(
    :setting,
    hid: 'azure',
    setting_fields: [
      build(:setting_field, hid: 'sub_id', value: 'abcdefg'),
      build(:setting_field, hid: 'pem_path', value: 'azure-cert.pem'),
      build(:setting_field, hid: 'api_url', value: 'https://management.core.windows.net')
    ]
  )
end

if find_gem('jellyfish-azure')
  require 'jellyfish_fog_azure'
  describe Jellyfish::Fog::Azure do
    ENV['JF_AZURE_SUB_ID'] = 'abcdefg'
    ENV['JF_AZURE_PEM_PATH'] = 'azure-cert.pem'
    ENV['JF_AZURE_API_URL'] = 'https://management.core.windows.net'
    it 'provisions a new infrastructure product' do
      Jellyfish::Fog::Azure::Mock.new.mock!
      azure_settings
      order_item = infrastructure_order_item
      item = Jellyfish::Fog::Azure::Infrastructure.new(order_item)
      item.provision
      expect(order_item.provision_status).to eq(:ok)
    end

    it 'provisions a new storage product' do
      Jellyfish::Fog::Azure::Mock.new.mock!
      azure_settings
      order_item = storage_order_item
      item = Jellyfish::Fog::Azure::Storage.new(order_item)
      item.provision
      expect(order_item.provision_status).to eq(:ok)
    end

    it 'creates a new connection' do
      Jellyfish::Fog::Azure::Mock.new.mock!
      connection = Jellyfish::Fog::Azure::Connection.new.connect
      expect(connection).to be_a_kind_of(::Fog::Compute::Azure::Mock)
    end
  end
end
