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
    
  
  # If status is finished or failed there's no turning back
  # If at least one has failed the overall status is failed
  # If all have finished but then the overall status is finished
  # If at least one is pending and no one has failed the overall status is pending
  # Finnaly there are only two statuses left working and ready, if one of them is not ready
  # then it must be working
  def realtime_status 
    return status if status == 'finished' or status == 'failed'
    
    self.import_modules.update_statuses

    if import_modules.load.select{ |im| im.status == 'failed'}.count > 0
      update_attribute(:status, 'failed')
    elsif import_modules.load.select{ |im| im.finished? }.count == import_modules.size
      update_attribute(:status, 'finished')
    elsif import_modules.load.select{ |im| im.status == 'pending' }.count > 0
      update_attribute(:status, 'pending')
    elsif import_modules.load.select{ |im| im.status != 'ready' }.count > 0 and status != 'working'
      update_attribute(:status, 'working')
    end
    status
  end

  private
  
  def already_processed?
    import_modules.load.count > 0
  end

end
