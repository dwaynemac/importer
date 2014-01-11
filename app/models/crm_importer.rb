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
      contacts_csv = open(file_path)
    else
      contacts_csv = open(file_url)
    end

    response = request_import
    if response.code == 201
      remote_import_id = JSON.parse(response)['id']
      self.update_attributes(status_url: Crm::HOST + '/v0/imports/' + remote_import_id)
    end
  end

  def map_status (response)
    JSON.parse(response)['import']['status']
  end
end
