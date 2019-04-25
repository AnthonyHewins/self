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

# Controller
gem 'bcrypt', require: 'bcrypt'

# Assets
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', git: "https://github.com/rails/webpacker.git"

# Views
gem 'semantic-ui-sass'
gem 'gravtastic'
gem 'turbolinks', '~> 5' # Disabled to prevent JS not reloading for Vue
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'katex'

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'factory_bot'
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'database_cleaner'
end

group :development do
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
