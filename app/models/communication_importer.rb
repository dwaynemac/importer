class CommunicationImporter < CrmImporter
  def file_path
    import.import_file.communications.path
  end

  def file_url
    import.import_file.communications.url
  end

  def request_import (csv)
    RestClient.post api_url,
                    app_key: Crm::API_KEY,
                    import: {
                      account_name: import.account.name,
                      object: 'communication',
                      file: csv,
                      headers: headers
                    }
  end

  def ready?
    import.import_modules.where(type: 'ContactsImportModule').first.finished? 
  end

  def my_name
    'Communications'
  end

  def headers
    case self.import.source_system
      when 'kshema'
        %w(id type contact_type persona_id fecha comosupo_id observations instructor_id
                          coeficiente_id school_id created_at updated_at enrolled)
      when 'sys'
        %w()
      when 'other'
        %w()
    end
  end
end
