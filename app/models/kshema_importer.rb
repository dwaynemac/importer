class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    cim = ContactsImportModule.create(import: @import)

    process_crm_imports
  end

  private

  def process_crm_imports
    CommunicationImporter.create(import: @import)
    CommentImporter.create(import: @import)
    DropOutImporter.create(import: @import)
    EnrollmentImporter.create(import: @import)
    FollowImporter.create(import: @import)
  end

end
