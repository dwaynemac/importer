# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :import_module do
    name 'contact'
  end
  factory :communication_importer do
    name 'communicationimporter'
    import
  end
  factory :comment_importer do
    name 'commentimporter'
    import
  end
  factory :drop_out_importer do
    name 'dropoutimporter'
    import
  end
  factory :follow_importer do
    name 'followimporter'
    import
  end
  factory :enrollment_importer do
    name 'enrollmentimporter'
    import
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
