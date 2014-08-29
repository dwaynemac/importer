class MailingImporter < ImportModule
  
  def status_params
    {app_key: Mailing::API_KEY, account_name: import.account.name}
  end
  
  def delegate_import
    if Rails.env == 'development'
      # use local file path on development
      csv = open(self.import.import_file.mailing.path)
    else
      # use s3 file on production
      csv = open_tmp_file(self.import.import_file.mailing.url)
    end

    response = RestClient.post Mailing::HOST + '/api/v0/imports',
                    app_key: Mailing::API_KEY,
                    account_name: import.account.name,
                    import: {
                      csv_file: csv,
                      headers: headers
                    }
    if response.code == 201
      remote_import_id = JSON.parse(response)['id']
      self.update_attribute(:status_url, Mailing::HOST + '/api/v0/imports/' + remote_import_id.to_s)
    end
  end

  def ready?
    true
  end

  def my_name
    "Mailing"
  end

  def map_status (response)
    JSON.parse(response)['status']
  end

  def headers
    ["","name", "description", "subject", "content", "", "", "trigger", "", "", "", "header_image_url", "footer_image_url"]
  end
    
end
