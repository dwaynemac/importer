class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    contacts_importer = ContactsImportModule.create(import: @import)
    communication_importer = CommunicationImporter.create(import: @import)
    comment_importer = CommentImporter.create(import: @import)
    drop_out_importer = DropOutImporter.create(import: @import)
    enrollment_importer = EnrollmentImporter.create(import: @import)
    follow_importer = FollowImporter.create(import: @import)


    contacts_importer.delegate_import
    communication_importer.delegate_import if communication_importer.ready?
    comment_importer.delegate_import if comment_importer.ready?
    drop_out_importer.delegate_import if drop_out_importer.ready?
    enrollment_importer.delegate_import if enrollment_importer.ready?(communication_importer.status)
    follow_importer.delegate_import if follow_importer.ready?
  end

end
