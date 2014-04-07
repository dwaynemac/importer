class EnrollmentImporter < CrmImporter
  def file_path
    import.import_file.enrollments.path
  end

  def file_url
    import.import_file.enrollments.url
  end

  def request_import (csv)
    RestClient.post api_url,
                    app_key: Crm::API_KEY,
                    import: {
                      account_name: import.account.name,
                      object: 'enrollment',
                      file: csv,
                      headers: headers
                    }
  end

  def ready?
    import.import_modules.where(type: 'CommunicationImporter').first.finished? 
  end

  def my_name
    'Enrollments'
  end

  def headers
    case self.import.source_system
      when 'kshema'
        %w(id fecha instructor_id persona_id contact_id school_id)
      when 'sys'
        %w(persona_id fecha instructor_id)
      when 'other'
        %w()
    end
  end
end
