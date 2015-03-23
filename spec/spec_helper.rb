# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'fog/azure'
ENV['RAILS_ENV'] ||= 'test'

# Create a fake provisioner class to store fake credentials for testing
class Provisioner
  attr_reader :order_item

  # TODO: Better testing system
  ::Fog.mock! # Set fog as mock.

  def initialize(order_item)
    @order_item = order_item
  end

  def self.provision(order_item_id)
    perform(order_item_id, :critical_error) { |order_item| new(order_item).provision }
  end

  def self.retire(order_item_id)
    perform(order_item_id, :warning_retirement_error) { |order_item| new(order_item).retire }
  end

  def azure_settings
    {
      'sub_id' => 'microsoftsubscriptionid', # your subscription id
      'pem_path' => 'azure-cert.pem', # your pem path
      'api_url' => 'https://management.core.windows.net'
    }
  end
end

require File.expand_path('../dummy/config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end