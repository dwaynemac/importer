class DropoutImporter < CrmImporter
  def file_path
    import.import_file.drop_outs.path
  end

  def file_url
    import.import_file.drop_outs.url
  end

  def request_import (csv)
    RestClient.post api_url,
                    app_key: Crm::API_KEY,
                    import: {
                      account_name: import.account.name,
                      object: 'drop_out',
                      file: csv,
                      headers: headers
                    }
  end

  def ready?
    import.import_modules.where(type: 'EnrollmentImporter').first.finished? 
  end

  def my_name
    'Drop outs'
  end

  def headers
    case self.import.source_system
      when 'kshema'
        %w(id persona_id fecha notas grado_id school_id instructor_id reasons)
      when 'sys'
        %w(fecha persona_id grado_id instructor_id)
      end
  end
end
