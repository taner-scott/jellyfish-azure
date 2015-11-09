require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Definition
    describe 'CustomPublicTemplateDefinition' do
      let(:product) { create :product }
      let(:cloud_client) do
        OpenStruct.new(
          storage: double,
          deployment: double,
          resource_group: double)
      end

      subject(:definition) { CustomPublicTemplateDefinition.new cloud_client, product }

      context 'when template loading succeeds' do
        before do
          product.settings[:az_custom_template_uri] = 'https://templates.com/test_template.json'

          allow(definition).to receive(:open)
            .with('https://templates.com/test_template.json')
            .and_return(arm_template_file(:simple_template))
        end

        context '#product_questions' do
          subject(:questions) { CustomPublicTemplateDefinition.product_questions }
          it_should_behave_like 'has_question', :az_custom_template_uri, :string, :text, true
        end

        context '#order_questions' do
          subject(:questions) { definition.order_questions }
          it_should_behave_like 'has_question', :az_location, :string, :az_location, true
          it_should_behave_like 'has_question', 'az_custom_param_param1', :string, :az_choice, false
          it_should_behave_like 'has_question', 'az_custom_param_param2', :string, :text, true
        end

        context '#parameter_values' do
          context 'az_custom_param_param1' do
            it { expect(definition.parameter_values 'az_custom_param_param1').to eq %w(one two three) }
          end

          context 'az_custom_param_param2' do
            it { expect(definition.parameter_values 'az_custom_param_param2').to be_nil }
          end
        end
      end

      context 'when template loading fails' do
        context 'invalid url' do
          before do
            product.settings[:az_custom_template_uri] = 'https://templates.com/test_template.json'

            allow(definition).to receive(:open)
              .with('https://templates.com/test_template.json')
              .and_raise(OpenURI::HTTPError.new('test failure', {}))
          end

          it do
            expect { definition.template }.to raise_error(
              ValidationError,
              'Validation error: az_custom_template_url: The template URL provided could not be found')
          end
        end

        context 'invalid template contents' do
          before do
            product.settings[:az_custom_template_uri] = 'https://templates.com/test_template.json'

            allow(definition).to receive(:open)
              .with('https://templates.com/test_template.json')
              .and_return(arm_template_file(:invalid_json))
          end

          it do
            expect { definition.template }.to raise_error ValidationError,
              'Validation error: az_custom_template_url: There was a problem parsing the template'
          end
        end
      end
    end
  end
end
