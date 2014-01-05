class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    cim = ContactsImportModule.create(import: @import)
    
    proccess_contacts_files
    proccess_attendance_imports

    # delegations will be done on background
  end

  private

  def proccess_attendance_imports
    ContactsFileImporter.create(import: @import)
    TimeSlotImporter.create(import: @import)
    AttendanceImporter.create(import: @import)
    TrialLessonImporter.create(import: @import)
  end

  def proccess_contacts_files
    ContactsFileImporter.create(import: @import)
  end

end
