# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account, :aliases => [:current_account] do
    sequence(:name) {|n| "Account #{n}" }
  end
end
