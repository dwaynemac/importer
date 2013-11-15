class CommunicationImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {app_key: Crm::API_KEY, import: {account_name: import.account.name}}
  end

  def delegate_import
    # Import communication csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      communication_csv = open(self.import.import_file.communications.path)
    else
      # use s3 file on production
      communication_csv = open(self.import.import_file.communications.url)
    end



    # Send file to crm module using import api
    response = RestClient.post Crm::HOST + '/v0/imports',
                    :app_key => Crm::API_KEY,
                    :import => {
                      :account_name => self.import.account.name,
                      :object => 'communication',
                      :file => communication_csv,
                      :headers => %w(id type contact_type persona_id fecha comosupo_id observations instructor_id
                        coeficiente_id school_id created_at updated_at enrolled)
                    }
    if(response.code == 201)
      # If import was created successfully create an import module that will show the status of this import
      import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Crm::HOST + '/api/v0/imports/' + import_id)
    end
  end
  
  def finished?
    self.realtime_status == 'finished'
  end

  def ready?
    self.import.import_modules.where(type: 'ContactsImportModule').first.finished?
  end
end
