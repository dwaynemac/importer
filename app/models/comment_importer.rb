class CommentImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {app_key: Crm::API_KEY, import: {account_name: import.account.name}}
  end

  def delegate_import
    # Import comment csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      comment_csv = open(self.import.import_file.comments.path)
    else
      # use s3 file on production
      comment_csv = open(self.import.import_file.comments.url)
    end



    # Send file to crm module using import api
    response = RestClient.post Crm::HOST + '/v0/imports',
                    :app_key => Crm::API_KEY,
                    :import => {
                      :account_name => self.import.account.name,
                      :object => 'comment',
                      :file => comment_csv,
                      :headers => %w(id instructor_id persona_id school_id type observations fecha
                                    confirmed done created_at updated_at)
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
