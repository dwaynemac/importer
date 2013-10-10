class ImportModule < ActiveRecord::Base
  belongs_to :import

  attr_accessible :name, :status, :status_url

  def realtime_status
    response = RestClient.get status_url, :params => {:app_key => Contacts::API_KEY, 'import[account_name]' => import.account.name}
    JSON.parse(response)['import']['status']
  end
end
