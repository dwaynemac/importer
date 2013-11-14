class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    cim = ContactsImportModule.create(import: @import)

    process_crm_imports
    proccess_attendance_imports

    # delegations will be done on background
  end

  private

  def process_crm_imports
    CommunicationImporter.create(import: @import)
    CommentImporter.create(import: @import)
    DropOutImporter.create(import: @import)
    EnrollmentImporter.create(import: @import)
    FollowImporter.create(import: @import)
  end

  def proccess_attendance_imports
    TimeSlotImporter.create(import: @import)
    AttendanceImporter.create(import: @import)
    TrialLessonImporter.create(import: @import)
  end

end
