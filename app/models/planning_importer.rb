class PlanningImporter < ImportModule
  
  def status_params
    {app_key: Planning::API_KEY, account_name: import.account.name}
  end
  
  def delegate
    reponse = RestClient.post Planning::HOST + '/v0/imports', status_params
    if response.code == 201
      remote_import_id = JSON.parse(response)['id']
      self.udpate_attibute(status_url: Planning::HOST + '/v0/imports' + remote_import_id)
    end
  end

  def ready?
    import.import_modules.where(type: 'ContactsImportModule').first.finished?
  end

  def my_name
    "Planning"
  end

  def map_status (response)
    JSON.parse(response)['import']['status']
  end
    
end
