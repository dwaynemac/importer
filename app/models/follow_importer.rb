class FollowImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Crm::API_KEY, 'import[account_name]' => import.account.name}
  end

  def delegate_import
    # Import follow csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      follow_csv = open(@import.import_file.follow.path)
    else
      # use s3 file on production
      follow_csv = open(@import.import_file.follow.url)
    end



    # Send file to crm module using import api
    response = RestClient.post Crm::HOST + '/v0/imports',
                    :app_key => Crm::API_KEY,
                    :import => {
                      :account_name => @import.account.name,
                      :object => 'follow',
                      :file => follow_csv,
                      :headers => %w(id nombre deleted firma genero apellido school_id cas_login follows)
                    }
    if(response.code == 201)
      # If import was created successfully create an import module that will show the status of this import
      import_id = JSON.parse(response)['id']
      self.update_attributes(status_url: Crm::HOST + '/v0/imports/' + import_id)
    end
  end
  
  def finished?
    self.realtime_status == 'finished'
  end

  def ready?
    self.import.import_modules.where(type: 'ContactsImportModule').first.finished?
  end
end
