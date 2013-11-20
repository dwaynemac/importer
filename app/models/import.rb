class Import < ActiveRecord::Base
  belongs_to :account

  mount_uploader :import_file, ImportFileUploader

  attr_accessible :import_file, :status

  has_many :import_modules

  after_save :process_import_file

  def finished?
    return realtime_status == 'finished'
  end

  def process_import_file
    if import_file.present? and not already_processed?
      importer = KshemaImporter.new(self)
      importer.process
    end
  end

  def realtime_status 
    return status if status == 'finished'
    if import_modules.load.select{ |im| not im.finished? }.count == 0
      update_attribute(:status, 'finished')
    end
    status
  end

  private
  
  def already_processed?
    import_modules.load.count > 0
  end

end
