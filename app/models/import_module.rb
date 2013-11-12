class ImportModule < ActiveRecord::Base
  belongs_to :import

  attr_accessible :name, :status, :status_url

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

  # Queries for unfinished import_modules and delegates those that are ready
  def self.delegate_ready_imports
    self.where.not(status: finished_status).each do |im|
      im.delegate_import if im.ready?
    end
  end

  private

  # if child class has a different finished status
  # this method should be overriden
  def self.finished_status
    'finished'
  end
end
