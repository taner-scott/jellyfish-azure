require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  describe DeploymentTemplate do
    shared_examples_for 'template_parameter' do |index, name, type, field, default_value, allowed_values = nil|
      context "parameter #{index}" do
        subject { template.parameters[index] }

        it "name should eq '#{name}'" do
          expect(subject.name).to eq name
        end
        it "type should eq '#{type}'" do
          expect(subject.type).to eq type
        end
        it "field should eq '#{field}'" do
          expect(subject.field).to eq field
        end
        it "default_value should eq '#{default_value}'" do
          expect(subject.default_value).to eq default_value
        end
        it "allowed_values should eq '#{allowed_values}'" do
          expect(subject.allowed_value).to eq allowed_values
        end
      end
    end

    let(:template) { arm_template :all_types_template }

    context 'parameter count' do
      subject { template.parameters.length }
      it { is_expected.to eq 5 }
    end

    it_should_behave_like 'template_parameter', 0, 'stringParam', :string, :text, nil
    it_should_behave_like 'template_parameter', 1, 'securestringParam', :string, :password, nil
    it_should_behave_like 'template_parameter', 2, 'intParam', :integer, :az_integer, nil
    it_should_behave_like 'template_parameter', 3, 'boolParam', :boolean, :checkbox, nil
    it_should_behave_like 'template_parameter', 4, 'stringChoiceParam', :string, :az_choice, nil, %w(one two)
  end
end
