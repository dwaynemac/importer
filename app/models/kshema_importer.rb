class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    cim = ContactsImportModule.create(import: @import)
    
    proccess_attendance_imports

    # delegations will be done on background
  end

  private

  def proccess_attendance_imports
    TimeSlotImporter.create(import: @import)
    AttendanceImporter.create(import: @import)
    TrialLessonImporter.create(import: @import)
  end

end
