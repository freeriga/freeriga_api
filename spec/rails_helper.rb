# frozen_string_literal: true

require 'database_cleaner'
require 'pp'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# require 'paper_trail/frameworks/rspec'
# require 'action_cable/testing/rspec'
Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f }
ActiveRecord::Migration.maintain_test_schema!
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include RequestSpecHelper, type: :request
  config.include RequestSpecHelper, type: :channel

  # config.include RswagExampleHelpers, type: :request 
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  # config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include FactoryBot::Syntax::Methods
  # start by truncating all the tables but then use the faster transaction strategy the rest of the time.
  config.before(:suite) do
    # pp 'before suite'
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.after(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  # # start the transaction strategy as examples are run
  # config.around(:each) do |example|
  #   DatabaseCleaner.cleaning do
  #     example.run
  #   end
  # end
  if Bullet.enable?
   config.before(:each) do
     Bullet.start_request
   end

   config.after(:each) do
     Bullet.perform_out_of_channel_notifications if Bullet.notification?
     Bullet.end_request
   end
 end
  # config.after(:all) do
  #   FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/test"]) if Rails.env.test?
  # end
end
