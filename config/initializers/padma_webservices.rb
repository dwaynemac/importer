module Accounts
  API_KEY = ENV['accounts_key'] || CONFIG['accounts_key']
end

module Contacts
  API_KEY = ENV['contacts_key'] || CONFIG['contacts_key']
end

module Attendance
  API_KEY = ENV['attendance_key'] || CONFIG['attendance_key']
  if Rails.env.development?
    HOST = "localhost:3015"
  elsif Rails.env.production?
    HOST = "padma-attendance.herokuapp.com"
  elsif Rails.env.test?
    HOST = "test"
  end
end
