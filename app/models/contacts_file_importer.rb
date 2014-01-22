class ContactsFileImporter < ImportModule

  def status_params
    { key: Kshema::API_KEY }
  end
 
  def delegate_import
    response = RestClient.post  Kshema::HOST + '/pws/v1/files_export',
                                key: Kshema::API_KEY,
                                environment: Rails.env,
                                account_name: self.import.account.name

    if(response.code == 201)
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Kshema::HOST + '/pws/v1/files_export/' + remote_import_id.to_s)
    end
  end

  def ready?
    self.import.import_modules.where(type: 'ContactsImportModule').first.finished?
  end

  def my_name
    "Contacts files"
  end

  def map_status (response)
    new_status = JSON.parse(response)['status']
    if new_status == 'failed'
      'pending'
    else
      new_status
    end
  end

end
