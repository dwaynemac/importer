class SysImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  # delegations will be done on background
  def process
    proccess_contacts_imports
    #proccess_attendance_imports
    proccess_crm_imports
  end

  private

  def proccess_attendance_imports
    TimeSlotImporter.create(import: @import)
    AttendanceImporter.create(import: @import)
    TrialLessonImporter.create(import: @import)
  end

  def proccess_contacts_imports
    ContactsImportModule.create(import: @import)
  end

  def proccess_crm_imports
    #CommentImporter.create(import: @import)
    CommunicationImporter.create(import: @import)
    #FollowImporter.create(import: @import)
    EnrollmentImporter.create(import: @import)
    DropoutImporter.create(import: @import)
  end

end
