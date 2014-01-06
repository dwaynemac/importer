class ContactsFileImporter < ImportModule

  def status_params
    { key: Kshema::API_KEY }
  end
 
  def delegate_import
    response = RestClient.post  Kshema::HOST + '/pws/v1/files_export',
                                key: Kshema::API_KEY,
                                account_name: self.import.account.name

    if(response.code == 201)
      remote_import_id = JSON.parse(response)['id']
      self.update_attributes(status_url: Kshema::HOST + '/pws/v1/files_export/' + remote_import_id)
    end
  end
  
  def finished?
    self.realtime_status == 'finished'
  end

  def failed?
    self.realtime_status == 'failed'
  end

  def ready?
    self.import.import_modules.where(type: 'ContactsImportModule').first.finished?
  end

  def my_name
    "Contacts files"
  end

  def realtime_status
    if self.status == 'finished' || self.status == 'failed'
      return self.status
    end
    
    response = RestClient.get status_url, :params => status_params
    if parse_status(response) == 'failed'
      self.update_attribute(:status, 'pending')
    else
      super(response)
    end
  end

  def parse_status (response)
    JSON.parse(response)['status']
  end

end
