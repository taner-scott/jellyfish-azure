require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Operation
    describe 'CustomPrivateProvision#execute' do
      let (:cloud_client) {
        OpenStruct.new(
          storage: double(),
          deployment: double(),
          resource_group: double())
      }

      let (:service) { create :service }
      let (:product) { create :product }
      let (:provider) { create :provider }
      let (:operation) {
        JellyfishAzure::Operation::CustomPrivateProvision.new cloud_client, provider, product, service
      }

      context 'when valid private storage settings are provided' do
        before {
          product.settings[:az_custom_name] = 'sa_name'
          product.settings[:az_custom_key] = 'sa_key'
          product.settings[:az_custom_container] = 'sa_container'
          product.settings[:az_custom_blob] = 'sa_blob'
          service.settings[:az_custom_location] = 'westus'
          service.settings[:az_custom_param_param1] = 'value1'
          service.settings[:az_custom_param_param2] = 'value2'

          allow(cloud_client.storage).to receive(:get_blob)
            .with('sa_name', 'sa_key', 'sa_container', 'sa_blob')
            .and_return(arm_template_json :simple_template)

          allow(cloud_client.storage).to receive(:get_blob_sas_uri)
            .with('sa_name', 'sa_key', 'sa_container', 'sa_blob', 30)
            .and_return('https://templates.com/test_template.json?sastoken=token')

          operation.setup
        }

        context 'template_url' do
          subject { operation.template_url }
          it { is_expected.to eq 'https://templates.com/test_template.json?sastoken=token' }
        end

        context 'location' do
          subject { operation.location }
          it { is_expected.to eq 'westus' }
        end

        context 'template_parameters' do
          subject { operation.template_parameters }
          it { is_expected.to include(templateBaseUrl: { value: 'https://templates.com/' }) }
          it { is_expected.to include(sasToken: { value: 'sastoken=token' }) }
          it { is_expected.to include(serviceName: { value: operation.resource_group_name }) }
          it { is_expected.to include(param1: { value: 'value1' }) }
          it { is_expected.to include(param2: { value: 'value2' }) }
        end
      end

      context 'when invald valid private storage settings are provided' do
        before {
          product.settings[:az_custom_name] = 'sa_name'
          product.settings[:az_custom_key] = 'sa_key'
          product.settings[:az_custom_container] = 'sa_container'
          product.settings[:az_custom_blob] = 'sa_blob'

          ex = Azure::Core::Error.new('test failure')
          allow(cloud_client.storage).to receive(:get_blob)
            .with('sa_name', 'sa_key', 'sa_container', 'sa_blob')
            .and_raise(ex)
        }

        it { expect { operation.setup }.to raise_error(ValidationError, 'There was a problem accessing the template: test failure') }
      end
    end
  end
end
