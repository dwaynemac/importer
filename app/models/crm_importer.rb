class CrmImporter < ImportModule

  def status_params
    { app_key: Crm::API_KEY, import: { account_name: import.account.name } }
  end
  
  # override in child class
  def file_path
  end

  # override in child class
  def file_url
  end

  # override in child class
  def request_import
  end

  def delegate_import
    if Rails.env == 'development'
      csv = open(file_path)
    else
      csv = open(file_url)
    end

    response = request_import csv
    if response.code == 201
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Crm::HOST + '/v0/imports/' + remote_import_id.to_s)
    end
  end

  def map_status (response)
    JSON.parse(response)['import']['status']
  end
end
