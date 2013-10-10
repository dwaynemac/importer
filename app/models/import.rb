class Import < ActiveRecord::Base
  belongs_to :account

  mount_uploader :import_file, ImportFileUploader

  attr_accessible :import_file

  has_many :import_modules

  after_save :process_import_file

  def process_import_file
    if import_file.present?
      importer = KshemaImporter.new(self)
      importer.process
    end
  end
end
