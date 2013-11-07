class ContactsImportModule < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Contacts::API_KEY, 'import[account_name]' => import.account.name}
  end

  def delegate_import
    # Import contacts csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      contacts_csv = open(self.import_file.contacts.path)
    else
      # use s3 file on production
      contacts_csv = open(self.import_file.contacts.url)
    end


    # Send file to contacts module using import api
    response = RestClient.post Contacts::HOST + '/v0/imports',
                    :app_key => Contacts::API_KEY,
                    :import => {
                      :account_name => self.account.name,
                      :file => contacts_csv,
                      :headers => %w(id dni nombres apellidos dire tel cel mail grado_id instructor_id coeficiente_id genero foto
                        fecha_nacimiento inicio_practicas profesion	notes follow indice_fidelizacion codigo_postal school_id
                        current_plan_id	created_at updated_at estimated_age	company	job	city locality business_phone
                        country_id state identity publish_on_gdp last_enrollment in_formation id_scan padma_id foto_migrated
                        id_scan_migrated padma_follow_id)
                    }
    if(response.code == 201)
      # If import was created successfully create an import module that will show the status of this import
      import_id = JSON.parse(response)['id']
      self.update_attributes(status_url: Contacts::HOST + '/v0/imports/' + import_id)
    end
  end
  
  def finished?
    self.realtime_status == 'finished'
  end

  #ContactImportModule (ContactImporter) is always ready
  def ready?
    true
  end

end
