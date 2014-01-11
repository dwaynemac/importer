class FollowImporter < CrmImporter
  def file_path
    import.import_file.follows.path
  end

  def file_url
    import.import_file.follows.url
  end

  def request_import (csv)
    RestClient.post Crm::HOST + '/v0/imports',
                    app_key: Crm::API_KEY,
                    import: {
                      account_name: import.account.name,
                      object: 'follow',
                      file: csv,
                      headers: ['follows', 'cas_login']
                    }
  end

  def ready?
    import.import_modules.where(type: 'ContactsImportModule').first.finished? 
  end

  def my_name
    'Follows'
  end
end
