class KshemaImporter
  attr_accessor :import

  def initialize(import)
    @import = import
  end

  def process
    cim = ContactsImportModule.create(import: @import)
    cim.delegate_import
    
    proccess_attendance_imports
  end

  private

  def proccess_attendance_imports
    tsi = TimeSlotImporter.create(import: @import)
    tsi.delegate_import
  end

end
