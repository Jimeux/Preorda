source 'https://rubygems.org'

ruby '2.1.0'

gem 'rails', '4.1.1'

gem 'pg' # postgresql DB

gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', '~> 3.1.1'

gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

gem 'turbolinks'   # Read about it here: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0' # For JSON APIs: https://github.com/rails/jbuilder

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use unicorn as the app server
gem 'unicorn'

# Pretty URLs
gem 'friendly_id', '~> 5.0.0'

# File uploads
gem 'paperclip',  github: 'thoughtbot/paperclip'

# Pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

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
  gem 'rspec-rails'
  gem 'capybara'
  # Deployment
  gem 'capistrano-rbenv',   github: 'capistrano/rbenv'
  gem 'capistrano-bundler', github: 'capistrano/bundler'
  gem 'capistrano-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'launchy'
  #gem 'simplecov', :require => false  # Test coverage
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use debugger
# gem 'debugger', group: [:development, :test]

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'