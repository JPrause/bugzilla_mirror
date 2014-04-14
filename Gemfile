source 'https://rubygems.org'

gem 'rails', '~> 4.0.0'
gem 'rails_config'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'more_core_extensions', :require => 'more_core_extensions/all'
gem 'active_bugzilla'
gem 'rugged'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'libv8'
  gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :test do
  gem 'rspec'
end

group :test, :development do
  gem 'rspec-rails'
end

gem 'foreman'

# Sidekiq specific gems
gem 'sidekiq', '~> 2.17'
gem 'sinatra', require: false
gem 'slim'

# Parallel used by Bugzilla SideKiq workers
gem 'parallel'

