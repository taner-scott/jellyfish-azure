require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Operation
    describe 'WebDevEnvironmentProvision#execute' do
      let (:service) { create :service }
      let (:product) { create :product }
      let (:provider) { create :provider }

      let (:cloud_client) {
        double('cloud_client',
          storage: double('storage_client'),
          deployment: double('resource_group_client'),
          resource_group: double('deployment_client'))
      }

      let (:operation) {
        JellyfishAzure::Operation::WebDevEnvironmentProvision.new cloud_client, provider, product, service
      }

      context 'when requesting the template url' do
        it 'should eq github URL' do
          expect(operation.template_url).to eq 'https://raw.githubusercontent.com/projectjellyfish/jellyfish-azure/master/templates/web-dev-environment/azuredeploy.json'
        end
      end

      context 'when requesting the location' do
        before {
          allow(service).to receive(:settings).and_return({
            az_custom_location: 'westus'
          })
        }
        it { expect(operation.location).to eq 'westus' }
      end

      context 'when requesting template parameters' do
        before {
          product.settings[:az_dev_web] = 'dev_web'
          product.settings[:az_dev_db] = 'dev_db'
          service.settings[:az_dev_dns] = 'dev_dns'
          service.settings[:az_username] = 'username'
          service.settings[:az_password] = 'password'
        }

        subject(:parameters) {
          operation.template_parameters
        }

        it { expect(parameters[:serviceName]).to eq({ value: operation.resource_group_name }) }
        it { expect(parameters[:webTechnology]).to eq({ value: 'dev_web' }) }
        it { expect(parameters[:dbTechnology]).to eq({ value: 'dev_db' }) }
        it { expect(parameters[:dnsNameForPublicIP]).to eq({ value: 'dev_dns' }) }
        it { expect(parameters[:adminUsername]).to eq({ value: 'username' }) }
        it { expect(parameters[:adminPassword]).to eq({ value: 'password' }) }
      end

      context 'when setting up the operation' do
        before {
          service.settings[:az_dev_dns] = 'dev_dns'
        }

        it 'setup succeeded' do
          allow(cloud_client.storage).to receive(:check_storage_account)
            .with('dev_dns')
            .and_return([true, ''])

          operation.setup
        end

        it 'dns name validation failed' do
          allow(cloud_client.storage).to receive(:check_storage_account)
            .with('dev_dns')
            .and_return([false, 'test failure'])

          expect { operation.setup }.to raise_error(ValidationError, 'test failure')
        end
      end
    end
  end
end
