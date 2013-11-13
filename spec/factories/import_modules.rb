# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :import_module do
    name 'contact'
  end
  factory :time_slot_importer do
    name "timeslotimporter"
    import
  end
  factory :contacts_import_module do
    name "contactsimportmodule"
    import
  end
  factory :attendance_importer do
    name "attendanceimporter"
    import
  end
  factory :trial_lesson_importer do
    name "triallessonimporter"
    import
  end
end