source 'https://rubygems.org'

ruby '2.1.3'

gem 'rails', '4.1.6'

gem 'pg' # postgresql DB

gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', '~> 3.1.1'

# JavaScript
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'react-rails', '~> 0.12.0.0'
gem 'turbolinks'   # Read about it here: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0' # For JSON APIs: https://github.com/rails/jbuilder

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use unicorn as the app server
gem 'unicorn'

# Pretty URLs
gem 'friendly_id', '~> 5.0.0'

# File uploads
gem 'paperclip', '~> 4.2'

# Pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# Search
#gem 'elasticsearch-model'
#gem 'elasticsearch-rails'

# Auth
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Scraping
gem 'mechanize'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  # Deployment
#  gem 'capistrano-rvm'
  gem 'capistrano-rbenv',   github: 'capistrano/rbenv'
  gem 'capistrano-bundler', github: 'capistrano/bundler'
  gem 'capistrano-rails'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
end

group :test do
  gem 'webmock'
  gem 'ffaker'
  gem 'site_prism'
  #gem 'simplecov', :require => false  # Test coverage
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use debugger
# gem 'debugger', group: [:development, :test]

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'