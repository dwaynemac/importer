class ImportModule < ActiveRecord::Base
  belongs_to :import

  attr_accessible :name, :status, :status_url

  def realtime_status
    unless self.status == 'finished'
      response = RestClient.get status_url, :params => status_params
      self.update_attributes(status: JSON.parse(response)['import']['status'])
    end
    self.status
  end
end
