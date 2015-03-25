source 'https://rubygems.org'

# Declare your gem's dependencies in jellyfish-fog-azure.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

gem 'rails', '4.1.7'
# Tests

gem 'fog-azure', git: 'https://github.com/projectjellyfish/fog-azure.git'

# .Env gem Gem
gem 'dotenv-rails'

group :development, :test do
  gem 'annotate'
  gem 'pg'
  gem 'awesome_print'
  gem 'brakeman', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner', '~> 1.3.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'license_finder'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'rubocop'
  gem 'seed_dump'
  gem 'spring'
  gem 'web-console', '~> 2.0.0'
  gem 'rubocop'
end
