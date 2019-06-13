source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'

# Server
gem 'puma', '~> 3.7'

# DB
gem 'pg'

# Model
gem 'bcrypt'

# Controller
gem 'will_paginate'

# Assets
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', git: "https://github.com/rails/webpacker.git"

# Views
gem 'semantic-ui-sass'
gem 'turbolinks', '~> 5'
gem 'jquery-rails'
gem 'katex'

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.13'
end

group :development, :test do
  gem 'byebug'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
