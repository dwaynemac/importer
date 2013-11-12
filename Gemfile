source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.1'

gem 'cancan'
# protected_attributes version < 1.0.2 has some problems with Rails 4.0.1
gem 'protected_attributes', '~> 1.0.4' # Rails 4 support for Mass Assignment Security
gem 'devise', github: 'plataformatec/devise', :branch => 'rails4'
gem 'devise_cas_authenticatable'
gem 'carrierwave'
gem 'fog'
gem 'accounts_client'
gem 'contacts_client', '~> 0.0.21'
gem 'crm_client', :path => '/home/alex/workspace/crm_client'

group :development do
  gem 'git-pivotal-tracker-integration'
end

group :development, :test do
  gem 'sqlite3'

  gem 'rspec-rails'
  gem 'factory_girl_rails'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'foreman'
  gem 'subcontractor', '~> 0.6.1'
end

group :production do
  gem 'pg'
  gem 'rails_log_stdout',           git: 'git://github.com/heroku/rails_log_stdout.git'
  gem 'rails3_serve_static_assets', git: 'git://github.com/heroku/rails3_serve_static_assets.git'
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
