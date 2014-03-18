class CommentImporter < CrmImporter
  def file_path
    import.import_file.comments.path
  end

  def file_url
    import.import_file.comments.url
  end

  def request_import (csv)
    RestClient.post api_url,
                    app_key: Crm::API_KEY,
                    import: {
                      account_name: import.account.name,
                      object: 'comment',
                      file: csv,
                      headers:  headers
                    }
  end

  def ready?
    import.import_modules.where(type: 'ContactsImportModule').first.finished? 
  end

  def my_name
    'Comments'
  end

  def headers
    case self.import.source_system
      when 'kshema'
        %w(id instructor_id persona_id school_id type observations fecha
                                      confirmed done created_at updated_at)
      when 'sys'
        %w()
      when 'other'
        %w()
    end
  end
end
