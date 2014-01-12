class CommunicationImporter < CrmImporter
  def file_path
    import.import_file.communications.path
  end

  def file_url
    import.import_file.communications.url
  end

  def request_import (csv)
    RestClient.post Crm::HOST + '/v0/imports',
                    app_key: Crm::API_KEY,
                    import: {
                      account_name: import.account.name,
                      object: 'communication',
                      file: csv,
                      headers: [ 
                        'instructor_id',
                        'fecha',
                        'coeficiente_id',
                        'observations',
                        'type',
                        'contact_type',
                        'persona_id',
                        'comosupo_id'
                      ]
                    }
  end

  def ready?
    import.import_modules.where(type: 'ContactsImportModule').first.finished? 
  end

  def my_name
    'Communications'
  end
end
