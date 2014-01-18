class ProductImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Fnz::API_KEY}
  end

  def map_status (response)
    JSON.parse(response)['status']
  end
  
  # Import products csv to fnz
  def delegate_import
    if Rails.env == 'development'
      # use local file path on development
      csv = open(self.import.import_file.products.path)
    else
      # use s3 file on production
      csv = open_tmp_file(self.import.import_file.products.url)
    end


    # Send file to fnz module using import api
    response = RestClient.post  Fnz::HOST + '/api/v0/imports',
                                app_key: Fnz::API_KEY,
                                import: {
                                  object: 'Product',
                                  padma_id: self.import.account.name,
                                  upload: csv
                                }
    if response.code == 201
      # If import was created successfully create a product importer
      #that will show the status of this import
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Fnz::HOST + '/api/v0/imports/' + remote_import_id.to_s)
    end
  end

  # Start migrating inmediatly
  def ready?
    true
  end

  def my_name
    "Products"
  end

end
