source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use POSTGRESQL as the database for Active Record
gem 'pg', '~> 1.1.3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use Rake
gem 'rake', '< 11.0'
# Serializing API Output
gem 'active_model_serializers'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
# Rate Limiting and Throttling
gem 'rack-attack'
# Documenting & Test Rails-based REST API
gem 'swagger-docs'
# For API docs UI
gem 'swagger-ui_rails'
# Managing Process
gem 'foreman'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'redis-objects'
gem 'redis-dump'

# Background Jobs
gem 'sidekiq'
gem 'sidekiq-failures'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # RSpec for Test cases
  gem 'rspec-rails'
  # Use Factory Girl for generating random test data
  gem 'factory_bot_rails'
end

group :test do
  # RSpec for Sidekiq
  gem 'rspec-sidekiq'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
