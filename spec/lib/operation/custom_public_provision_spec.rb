require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Operation
    describe 'CustomPublicProvision#execute' do
      let(:cloud_client) do
        OpenStruct.new(
          storage: double,
          deployment: double,
          resource_group: double)
      end

      let(:service) { create :service }
      let(:product) { create :product }
      let(:provider) { create :provider }
      let(:operation) do
        JellyfishAzure::Operation::CustomPublicProvision.new cloud_client, provider, product, service
      end

      context 'when a valid template url is provided' do
        before do
          product.settings[:az_custom_template_uri] = 'https://templates.com/test_template.json'
          service.settings[:az_location] = 'westus'
          service.settings[:az_custom_param_param1] = 'value1'
          service.settings[:az_custom_param_param2] = 'value2'

          allow_any_instance_of(JellyfishAzure::Definition::CustomPublicTemplateDefinition).to receive(:open)
            .with('https://templates.com/test_template.json')
            .and_return(arm_template_file(:simple_template))

          operation.setup
        end

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
        before do
          product.settings[:az_custom_template_uri] = 'https://templates.com/test_template.json'

          allow_any_instance_of(JellyfishAzure::Definition::CustomPublicTemplateDefinition).to receive(:open)
            .with('https://templates.com/test_template.json')
            .and_raise(OpenURI::HTTPError.new('test failure', ''))
        end

        it do
          expect { operation.setup }.to raise_error(
            ValidationError,
            'The template URL provided could not be found') do |error|
              expect(error.field).to eq :az_custom_template_url
            end
        end
      end
    end
  end
end
