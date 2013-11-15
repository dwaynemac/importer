class DropOutImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {app_key: Crm::API_KEY, import: {account_name: import.account.name}}
  end

  def delegate_import
    # Import drop_out csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      drop_out_csv = open(self.import.import_file.drop_outs.path)
    else
      # use s3 file on production
      drop_out_csv = open(self.import.import_file.drop_outs.url)
    end



    # Send file to crm module using import api
    response = RestClient.post Crm::HOST + '/v0/imports',
                    :app_key => Crm::API_KEY,
                    :import => {
                      :account_name => self.import.account.name,
                      :object => 'drop_out',
                      :file => drop_out_csv,
                      :headers => %w(id persona_id fecha notas grado_id school_id reasons)
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
    self.import.import_modules.where(type: 'EnrollmentImporter').first.finished?
  end
end
