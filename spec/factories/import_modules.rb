# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :import_module do
    name 'contact'
  end
  factory :communication_importer do
    name 'communicationimporter'
    import
  end
  factory :contacts_import_module do
    name 'contactsimportmodule'
    import
  end
end
