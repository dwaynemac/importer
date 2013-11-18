class PersonasCommentImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {app_key: Crm::API_KEY, import: {account_name: import.account.name}}
  end

  def delegate_import
    # Import comment from personas csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      comment_csv = open(self.import.import_file.personas.path)
    else
      # use s3 file on production
      comment_csv = open(self.import.import_file.personas.url)
    end



    # Send file to crm module using import api
    response = RestClient.post Crm::HOST + '/v0/imports',
                    :app_key => Crm::API_KEY,
                    :import => {
                      :account_name => self.import.account.name,
                      :object => 'comment',
                      :file => comment_csv,
                      :headers => %w(persona_id dni nombres apellidos dire tel cel mail grado_id instructor_id
                          coeficiente_id genero foto fecha_nacimiento inicio_practicas profesion observations follow
                          indice_fidelizacion codigo_postal school_id current_plan_id created_at fecha
                          estimated_age company job city locality business_phone country_id state identity
                          publish_on_gdp last_enrollment in_formation id_scan)
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
