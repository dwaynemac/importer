class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    # Import contacts csv to padma_contacts
    contacts_csv = @import.import_file.contacts
    @import.modules.create(name: "contacts", status: "importing")
    # TODO: Send file to padma_contacts
  end
end