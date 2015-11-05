require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Operation
    describe 'CustomPublicProvision#execute' do
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
        JellyfishAzure::Operation::CustomPublicProvision.new cloud_client, provider, product, service
      }

      context 'when a valid template url is provided' do
        before {
          allow(product).to receive(:settings).and_return({
            az_custom_template_uri: 'https://templates.com/test_template.json'
          })
          allow(service).to receive(:settings).and_return({
            az_custom_location: 'westus',
            az_custom_param_param1: 'value1',
            az_custom_param_param2: 'value2'
          })

          allow(operation).to receive(:open).with('https://templates.com/test_template.json')
            .and_return(JellyfishAzure::Factories.template_file(:simple_template))

          operation.setup
        }

        context 'template url' do
          subject { operation.template_url }
          it { is_expected.to eq 'https://templates.com/test_template.json' }
        end

        context 'location' do
          subject { operation.location }
          it { is_expected.to eq 'westus' }
        end

        context 'template_parameters' do
          subject { operation.template_parameters }
          it { is_expected.to include(templateBaseUrl: { value: 'https://templates.com/' }) }
          it { is_expected.to include(serviceName: { value: operation.resource_group_name }) }
          it { is_expected.to include(param1: { value: 'value1' }) }
          it { is_expected.to include(param2: { value: 'value2' }) }
        end
      end

      context 'when an invalid template url is provided' do
        before {
          allow(product).to receive(:settings).and_return({
            az_custom_template_uri: 'https://templates.com/test_template.json'
          })

          allow(operation).to receive(:open).with('https://templates.com/test_template.json')
            .and_raise(OpenURI::HTTPError.new('test failure', ''))
        }

        it { expect { operation.setup }.to raise_error(ValidationError, 'test failure') }
      end
    end
  end
end
