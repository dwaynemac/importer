class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  # delegations will be done on background
  def process
    proccess_contacts_imports
    proccess_attendance_imports
    process_fnz_imports
  end

  private

  def proccess_attendance_imports
    TimeSlotImporter.create(import: @import)
    AttendanceImporter.create(import: @import)
    TrialLessonImporter.create(import: @import)
  end

  # FNZ need the agents use instructors csv
  def process_fnz_imports
    ProductImporter.create(import: @import)
    SaleImporter.create(import: @import)
    MembershipImporter.create(import: @import)
    InstallmentImporter.create(import: @import)
  end

  def proccess_contacts_imports
    ContactsImportModule.create(import: @import)
    ContactsFileImporter.create(import: @import)
  end

  def proccess_crm_imports
    CommentImporter.create(import: @import)
    CommunicationImporter.create(import: @import)
    FollowImporter.create(import: @import)
    EnrollmentImporter.create(import: @import)
  end

end
