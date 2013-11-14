class EnrollmentImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Crm::API_KEY, 'import[account_name]' => import.account.name}
  end

  def delegate_import
    # Import enrollment csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      enrollment_csv = open(@import.import_file.enrollment.path)
    else
      # use s3 file on production
      enrollment_csv = open(@import.import_file.enrollment.url)
    end



    # Send file to crm module using import api
    response = RestClient.post Crm::HOST + '/v0/imports',
                    :app_key => Crm::API_KEY,
                    :import => {
                      :account_name => @import.account.name,
                      :object => 'enrollment',
                      :file => enrollment_csv,
                      :headers => %w(id fecha instructor_id persona_id contact_id school_id)
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
    self.import.import_modules.where(type: 'CommunicationImporter').first.finished?
  end
end