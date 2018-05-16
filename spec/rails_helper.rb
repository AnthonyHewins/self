require_relative 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_bot'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
  
  config.include FactoryBot::Syntax::Methods

  config.before(:all) do
    FactoryBot.reload
  end
  
  config.fixture_path = Rails.root.join("spec/fixtures").to_s

  config.filter_rails_from_backtrace!
end
