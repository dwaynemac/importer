class ContactsFileImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    { app_key: Kshema::API_KEY }
  end
 
  def delegate_import
    response = RestClient.post Kshema::HOST + 'api/v1/files_export',
                    app_key: Kshema::API_KEY,
                    account_name: self.import.account.name,
                    school_id: self.get_school_id 

    if(response.code == 201)
      remote_import_id = JSON.parse(response)['id']
      self.update_attributes(status_url: Kshema::HOST + 'api/v1/files_export/' + remote_import_id)
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
    if self.status_url.nil? || self.status == 'finished' || self.status == 'failed'
      return self.status
    end
    
    json = JSON.parse(RestClient.get status_url, :params => status_params)
    self.update_attribute(:status, json['status'])

    self.status
  end

  private
  
  def get_school_id
    #TODO  
  end

end
