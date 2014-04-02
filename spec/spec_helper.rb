require "capybara/poltergeist"
Capybara.javascript_driver = :poltergeist

# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require "rspec/rails"
require "active_record"
require "database_cleaner"
require "factory_girl"

Rails.backtrace_cleaner.remove_silencers!

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

# require factories
Dir[File.join(ENGINE_RAILS_ROOT, "spec/factories/**/*.rb")].each {|f| require f }

# require dummy application code
Dir[File.join(ENGINE_RAILS_ROOT, "spec/dummy/app/**/*.rb")].each {|f| require f }


RSpec.configure do |config|
  # config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
  config.include ExpectationHelper, type: :feature

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
