require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  describe DeploymentTemplate do
    describe '#parameters' do
      context 'when parameters are parsed' do
        let(:template) { arm_template :simple_template }

        it 'there are two parameters' do
          expect(template.parameters.length).to eq 2
        end

        it 'the parameter names are valid' do
          expect(template.parameters[0].name).to eq 'param1'
          expect(template.parameters[1].name).to eq 'param2'
        end

        it 'the default value is set' do
          expect(template.parameters[0].default_value).to eq 'default'
        end

        it 'the default value is nil' do
          expect(template.parameters[1].default_value).to eq nil
        end

        it 'the required value is true' do
          expect(template.parameters[1].required).to be true
        end

        it 'the required value is false' do
          expect(template.parameters[0].required).to be false
        end

        it 'the first parameter has allowed values' do
          expect(template.parameters[0].allowed_value).to eq %w(one two three)
        end

        it 'the second param has no allowed values' do
          expect(template.parameters[1].allowed_value).to be nil
        end
      end

      context 'when parameter types are parsed' do
        let(:template) { arm_template :all_types_template }

        it 'the stringParam is of type string' do
          expect(template.parameters[0].type).to eq :string
        end

        it 'the securestringParam is of type string' do
          expect(template.parameters[1].type).to eq :string
        end

        it 'the intParam is of type integer' do
          expect(template.parameters[2].type).to eq :integer
        end

        it 'the boolParam is of type boolean' do
          expect(template.parameters[3].type).to eq :boolean
        end
      end

      context 'when parameter field types are parsed' do
        let(:template) { arm_template :all_types_template }

        it 'the stringParam has field type text' do
          expect(template.parameters[0].field).to eq :text
        end

        it 'the securestringParam has field type password' do
          expect(template.parameters[1].field).to eq :password
        end

        it 'the intParam has field type az_integer' do
          expect(template.parameters[2].field).to eq :az_integer
        end

        it 'the boolParam has field type checkbox' do
          expect(template.parameters[3].field).to eq :checkbox
        end

        it 'the stringChoiceParam has field type az_choice' do
          expect(template.parameters[4].field).to eq :az_choice
        end
      end
    end
  end
end
