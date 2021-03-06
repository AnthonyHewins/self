source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'

# Server
gem 'puma', '~> 3.7'

# Middleware
gem 'rack-attack'

# DB
gem 'pg'

# Model
gem 'bcrypt'

# Controller
gem 'will_paginate'

# Assets
gem 'uglifier', '>= 1.3.0'

# Views
gem 'semantic-ui-sass'
gem 'turbolinks', '~> 5'
gem 'jquery-rails'
gem 'jquery-minicolors-rails'

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'web-console', '>= 3.3.0'
  gem 'rubocop-rails', require: false
  gem 'bundler-audit'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.13'
  gem 'rails-controller-testing'
end

group :production do
  gem 'sitemap_generator'
end

group :development, :test do
  gem 'byebug'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
