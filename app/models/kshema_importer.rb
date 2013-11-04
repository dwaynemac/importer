class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    cim = ContactsImportModule.create(import: @import)
    cim.delegate_import

    # register other modules here
  end

end
