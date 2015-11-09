require 'spec_helper'
require 'jellyfish_azure'
require 'azure/core/http/http_error.rb'

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

      subject(:definition) { CustomPrivateTemplateDefinition.new cloud_client, product }

      before do
        product.settings[:az_custom_name] = 'sa_name'
        product.settings[:az_custom_key] = 'sa_key'
        product.settings[:az_custom_container] = 'sa_container'
        product.settings[:az_custom_blob] = 'sa_blob'

        allow(cloud_client.storage).to receive(:get_blob)
          .with('sa_name', 'sa_key', 'sa_container', 'sa_blob')
          .and_return(arm_template_json :simple_template)
      end

      context '#order_questions' do
        subject(:questions) { CustomPrivateTemplateDefinition.product_questions }
        it_should_behave_like 'has_question', :az_custom_name, :string, :text, true
        it_should_behave_like 'has_question', :az_custom_key, :string, :password, true
        it_should_behave_like 'has_question', :az_custom_container, :string, :text, true
        it_should_behave_like 'has_question', :az_custom_blob, :string, :text, true
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

      context 'when template loading fails' do
        context 'invalid service name' do
          before do
            allow(cloud_client.storage).to receive(:get_blob)
              .and_raise(Faraday::ConnectionFailed, 'test failure')
          end

          it do
            expect { definition.template }.to raise_error(
              ValidationError,
              'Validation error: az_custom_name: Name or service not known')
          end
        end

        context 'invalid template contents' do
          before do
            allow(cloud_client.storage).to receive(:get_blob)
              .and_return(arm_template_json(:invalid_json))
          end

          it do
            expect { definition.template }.to raise_error ValidationError,
              'Validation error: az_custom_blob: There was a problem parsing the template'
          end
        end
      end
    end
  end
end
