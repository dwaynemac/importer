class SaleImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Fnz::API_KEY}
  end

  def parse_status (response)
    JSON.parse(response)['status']
  end
 
  def delegate_import
    if Rails.env == 'development'
      csv = open(self.import.import_file.sales.path)
    else
      csv = open(self.import.import_file.sales.url)
    end

    # Send file to fnz module using import api
    response = RestClient.post  Fnz::HOST + '/api/v0/imports',
                                app_key: Fnz::API_KEY,
                                padma_id: self.import.account.name,
                                import: {
                                    object: 'Product',
                                    upload: csv
                                }
    if response.code == 201
      # If import was created successfully create a trial lesson importer
      # that will show the status of this import
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Fnz::HOST + '/api/v0/imports/' + remote_import_id.to_s)
    end
  end
  
  def finished?
    self.realtime_status == 'finished'
  end

  # Wait for products and contacts import to finish
  def ready?
    self.import.import_modules.where(type: 'ProductImporter').first.finished? &&
    self.import.import_modules.where(type: 'ContactsImportModule').first.finished?
  end

  def my_name
    "Trial Lessons"
  end

end
