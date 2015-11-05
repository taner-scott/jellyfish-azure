require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Cloud
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
            expect(template.parameters[0].allowed_value).to eq [ 'one', 'two', 'three' ]
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

      describe '#get_questions' do
        context 'when questions are generated' do
          let(:template) { arm_template :simple_template }

          let (:questions) {
            template.get_questions('prefix_', [])
          }

          it 'two questions are returned' do
            expect(questions.length).to eq 2
          end

          it 'the label is using the parameter name' do
            expect(questions[0][:label]).to eq 'param1'
          end

          it 'the name is using the parameter name and prefix' do
            expect(questions[0][:name]).to eq 'prefix_param1'
          end

          it 'the type is using the parameter type' do
            expect(questions[0][:value_type]).to eq :string
          end

          it 'the type is using the parameter field' do
            expect(questions[0][:field]).to eq :az_choice
          end

          it 'the required flag is false' do
            expect(questions[0][:required]).to be false
          end
        end

        context 'when parameters are filtered' do
          let(:template) { arm_template :simple_template }

          let (:questions) {
            template.get_questions('prefix_', [ 'param1' ])
          }

          it 'only one question is returned' do
            expect(questions.length).to eq 1
            expect(questions[0][:label]).to eq 'param2'
          end
        end
      end

      describe '#find_allowed_values' do
        # parameter with allowed values
        # no parameter found
        # parameter name too short
        # parameter with no allowed values
      end

      describe '#apply_parameters' do
        # all values found
        # missing string value
        # missing boolean value
      end
    end
  end
end
