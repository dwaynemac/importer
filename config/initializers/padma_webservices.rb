module Accounts
  API_KEY = ENV['accounts_key'] || CONFIG['accounts_key']
end

module Contacts
  API_KEY = ENV['contacts_key'] || CONFIG['contacts_key']
end

module Crm
  API_KEY = ENV['crm_key'] || CONFIG['crm_key']
end