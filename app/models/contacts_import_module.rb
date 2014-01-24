class ContactsImportModule < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    { app_key: Contacts::API_KEY, account_name: import.account.name }
  end

  def handle_failed_rows?
    true
  end
 
  def delegate_import
    # Import contacts csv to padma_contacts
    if Rails.env == 'development'
      # use local file path on development
      contacts_csv = open(self.import.import_file.contacts.path)
    else
      # use s3 file on production
      contacts_csv = open_tmp_file(self.import.import_file.contacts.url)
    end


    begin
      # Send file to contacts module using import api
      response = RestClient.post Contacts::HOST + '/v0/imports',
                      :app_key => Contacts::API_KEY,
                      :account_name => self.import.account.name,
                      :import => {
                        :file => contacts_csv,
                        :headers => %w(id dni nombres apellidos dire tel cel mail grado_id instructor_id coeficiente_id genero foto
                          fecha_nacimiento inicio_practicas profesion	notes follow indice_fidelizacion codigo_postal school_id
                          current_plan_id	created_at updated_at estimated_age	company	job	city locality business_phone
                          country_id state identity publish_on_gdp last_enrollment in_formation id_scan padma_id foto_migrated
                          id_scan_migrated padma_follow_id)
                      }
      if(response.code == 201)
        # If import was created successfully create an import module that will show the status of this import
        remote_import_id = JSON.parse(response)['id']
        self.update_attributes(status_url: Contacts::HOST + '/v0/imports/' + remote_import_id)
      end
    rescue RestClient::Exception => e
      response_body = JSON.parse(e.response)
      Rails.logger.warn "ContactsImportModule##{self.id} #{response_body['message']}. Errors: #{response_body['errors']}"
    end
  end

  # destroys import on remote module and then destroys self
  def rollback
    if self.failed? && !self.rollbacked?
      response = RestClient.delete resource_uri, app_key: Contacts::API_KEY
      if response.code == 200
        self.update_attribute(:status, 'rollbacked')
      else
        return false
      end
    end
  end

  def rollbacked?
    self.realtime_status == 'rollbacked'
  end

  #ContactImportModule (ContactImporter) is always ready
  def ready?
    true
  end

  def my_name
    "Contacts"
  end

  def map_status (response)
    json = JSON.parse(response)
    if json['import']['failed_rows'].to_i > 0 and json['import']['status'] == 'finished'
      self.update_attribute(:failed_rows, true)
      'pending'
    else
      json['import']['status']
    end
  end

  def map_processed_lines(response)
    json = JSON.parse(response)
    failed = json['import']['failed_rows'].to_i
    successfull = json['import']['imported_rows'].to_i
    failed + successfull
  end

end
