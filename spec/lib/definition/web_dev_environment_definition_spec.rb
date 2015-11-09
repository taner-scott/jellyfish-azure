require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Definition
    describe 'WebDevEnvironmentDefinition' do
      subject(:definition) { WebDevEnvironmentDefinition.new }

      context '#product_questions' do
        subject(:questions) { WebDevEnvironmentDefinition.product_questions }
        it_should_behave_like 'has_question', :az_dev_web, :string, :az_dev_web, true
        it_should_behave_like 'has_question', :az_dev_db, :string, :az_dev_db, true
      end

      context '#order_questions' do
        subject(:questions) { definition.order_questions }
        it_should_behave_like 'has_question', :az_location, :string, :az_location, true
        it_should_behave_like 'has_question', :az_dev_dns, :string, :text, true
        it_should_behave_like 'has_question', :az_username, :string, :text, true
        it_should_behave_like 'has_question', :az_password, :string, :password, true
      end
    end
  end
end
