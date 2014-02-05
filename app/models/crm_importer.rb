class CrmImporter < ImportModule

  def status_params
    { app_key: Crm::API_KEY, import: { account_name: import.account.name }, account_name: import.account.name }
  end

  def handle_failed_rows?
    true
  end
  
  # override in child class
  def file_path
  end

  # override in child class
  def file_url
  end

  # override in child class
  def request_import
  end

  def api_url
    Crm::HOST + '/api/v0/imports/'
  end

  def delegate_import
    if Rails.env == 'development'
      csv = open(file_path)
    else
      csv = open_tmp_file(file_url)
    end

    response = request_import csv
    if response.code == 201
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: api_url + remote_import_id.to_s)
    end
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
