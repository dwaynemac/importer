class ImportModule < ActiveRecord::Base
  belongs_to :import

  attr_accessible :name, :status, :status_url

  # override in child class
  def status_params
  end

  def realtime_status
    return nil if status_url.nil?
    unless self.status == 'finished'
      response = RestClient.get status_url, :params => status_params
      self.update_attributes(status: JSON.parse(response)['import']['status'])
    end
    self.status
  end

  def ready?
  end
end
