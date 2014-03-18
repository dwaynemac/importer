class FollowImporter < CrmImporter
  def file_path
    import.import_file.follows.path
  end

  def file_url
    import.import_file.follows.url
  end

  def request_import (csv)
    RestClient.post api_url,
                    app_key: Crm::API_KEY,
                    import: {
                      account_name: import.account.name,
                      object: 'follow',
                      file: csv,
                      headers: headers
                    }
  end

  def ready?
    import.import_modules.where(type: 'ContactsImportModule').first.finished? 
  end

  def my_name
    'Follows'
  end

  def headers
    case self.import.source_system
      when 'kshema'
        %w(id nombre deleted firma genero apellido school_id cas_login follows)
      when 'sys'
        %w()
      when 'other'
        %w()
    end
  end
end
