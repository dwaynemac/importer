module Accounts
  API_KEY = ENV['accounts_key']
end

module Contacts
  API_KEY = ENV['contacts_key']
end

module Fnz
  API_KEY = ENV['fnz_key']
  if Rails.env.development?
    HOST = "localhost:3008"
  elsif Rails.env.production?
    HOST = "fnz.herokuapp.com"
  elsif Rails.env.staging?
    HOST = "fnz-staging.herokuapp.com"
  elsif Rails.env.test?
    HOST = "test"
  end
end

module Kshema
  API_KEY = ENV['kshema_key']
  if Rails.env.production? || Rails.env.staging?
    HOST = "https://www.metododerose.org/kshema"
  elsif Rails.env.development?
    HOST = "localhost:4000"
  elsif Rails.env.test?
    HOST = "test"
  end
end

module Attendance
  API_KEY = ENV['attendance_key']
  if Rails.env.development?
    HOST = "localhost:3015"
  elsif Rails.env.production?
    HOST = "padma-attendance.herokuapp.com"
  elsif Rails.env.staging?
    HOST = "padma-attendance-staging.herokuapp.com"
  elsif Rails.env.test?
    HOST = "test"
  end
end

module Crm
  API_KEY = ENV['crm_key']
  if Rails.env.development?
    HOST = "localhost:3000"
  elsif Rails.env.production?
    HOST = "crm.padm.am"
  elsif Rails.env.staging?
    HOST = "padma-crm-staging.herokuapp.com"
  elsif Rails.env.test?
    HOST = "test"
  end
end

module Planning
  API_KEY = ENV['planning_key']

  if Rails.env.development?
    HOST = 'localhost:3020'
  elsif Rails.env.test?
    HOST = 'test'
  elsif Rails.env.production?
    HOST = 'planning.padm.am'
  elsif Rails.env.staging?
    HOST = 'padma-planning-staging.heroku.com'
  end
end

module Mailing
  API_KEY = ENV['mailing_key']
  
  if Rails.env.development?
    HOST = 'localhost:3025'
  elsif Rails.env.test?
    HOST = 'test'
  elsif Rails.env.production?
    HOST = 'mailing.padm.am'
  elsif Rails.env.staging?
    HOST = 'padma-mailing-staging.heroku.com'
  end
end

class LogicalModel
  if Rails.env.production? || Rails.env.staging?
    def self.logger
      Logger.new(STDOUT)
    end
  end
end
