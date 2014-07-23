source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.2'

gem 'cancan'
gem 'protected_attributes', '~> 1.0.5' # Rails 4 support for Mass Assignment Security
gem 'devise', '~> 3.1'
gem 'devise_cas_authenticatable'
gem 'carrierwave'

gem 'unf'
gem 'fog'

gem 'accounts_client'
gem 'contacts_client', '~> 0.0.21'

gem 'figaro'

gem 'zip'

gem 'i18n', '~> 0.6.6'

group :development do
  gem 'git-pivotal-tracker-integration'

  gem 'foreman'
  gem 'subcontractor', '~> 0.6.1'

  gem 'byebug', require: false

  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'coveralls', require: false
end

group :development, :test do
  gem 'sqlite3'

  gem 'rake' # add rake dependency for travis-ci

  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'execjs'
gem 'therubyracer'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

gem 'rubyzip', :require => 'zip/zip'

gem 'bootstrap-sass'

gem 'rest-client'

group :doc do
  gem 'sdoc', require: false
  gem 'yard', '~> 0.8.3'
  gem 'yard-restful'
end
