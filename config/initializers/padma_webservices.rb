module Accounts
  API_KEY = ENV['accounts_key']
end

module Contacts
  API_KEY = ENV['contacts_key']
end

module Kshema
  API_KEY = ENV['kshema_key']
  if Rails.env.production?
    HOST = "metododerose.org/kshema"
  elsif Rails.env.development?
    HOST = "xxx"
  end
end

module Attendance
  API_KEY = ENV['attendance_key']
  if Rails.env.development?
    HOST = "localhost:3015"
  elsif Rails.env.production?
    HOST = "padma-attendance.herokuapp.com"
  elsif Rails.env.test?
    HOST = "test"
  end
end
