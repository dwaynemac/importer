class MailingImporter < ImportModule
  
  def status_params
    {app_key: Mailing::API_KEY, account_name: import.account.name}
  end
  
  def delegate_import
    response = RestClient.post Mailing::HOST + '/api/v0/imports', status_params
    if response.code == 201
      remote_import_id = JSON.parse(response)['id']
      self.update_attribute(:status_url, Mailing::HOST + '/api/v0/imports/' + remote_import_id.to_s)
    end
  end

  def ready?
    true
  end

  def my_name
    "Mailing"
  end

  def map_status (response)
    JSON.parse(response)['import']['status']
  end
    
end
