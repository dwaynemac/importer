class ProductImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Attendance::API_KEY}
  end

  def parse_status (response)
    JSON.parse(response)['status']
  end
  
  # Import time_slots csv to attendance
  def delegate_import
    if Rails.env == 'development'
      # use local file path on development
      csv = open(self.import.import_file.products.path)
    else
      # use s3 file on production
      csv = open(self.import.import_file.products.url)
    end


    # Send file to attendance module using import api
    # The last two headers are: vacancy (it doesn't matter) and school_id (already imported)
    response = RestClient.post  Fnz::HOST + '/api/v0/imports',
                                app_key: Fnz::API_KEY,
                                padma_id: self.import.account.name,
                                import: {
                                  object: 'Product',
                                  upload: csv
                                }
    if response.code == 201
      # If import was created successfully create a time_slot importer
      #that will show the status of this import
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Fnz::HOST + '/api/v0/imports/' + remote_import_id.to_s)
    end
  end

  def finished?
    self.realtime_status == 'finished'
  end

  def ready?
    true
  end

  def my_name
    "Products"
  end

end
