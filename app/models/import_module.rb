class ImportModule < ActiveRecord::Base
  belongs_to :import

  attr_accessible :name, :status, :status_url

  def self.delegated
    self.where.not(status_url: nil)
  end

  def self.not_delegated
    self.where(status_url: nil)
  end

  def self.not_finished
    self.where("status <> 'finished' OR status IS NULL")
  end

  # override in child class
  def status_params
  end

  # override in child class
  def finished?
  end

  # override in child class
  def ready?
  end

  def realtime_status
    return nil if status_url.nil?
    unless self.status == 'finished'
      response = RestClient.get status_url, :params => status_params
      self.update_attributes(status: JSON.parse(response)['import']['status'])
    end
    self.status
  end

  def self.update_statuses
    self.not_finished.delegated.each do |im|
      im.realtime_status
    end
  end

  # Queries for unfinished import_modules and delegates those that are ready
  def self.delegate_ready_imports
    # FIXME if an import_module's finished status is not "finished" this wont work for it.
    self.not_finished.not_delegated.each do |im|
      im.delegate_import if im.ready?
    end
  end
end
