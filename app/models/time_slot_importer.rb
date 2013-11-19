class TimeSlotImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Attendance::API_KEY}
  end
  
  # Import time_slots csv to attendance
  def delegate_import
    if Rails.env == 'development'
      # use local file path on development
      csv = open(self.import.import_file.time_slots.path)
    else
      # use s3 file on production
      csv = open(self.import.import_file.time_slots.url)
    end


    # Send file to attendance module using import api
    # The last two headers are: vacancy (it doesn't matter) and school_id (already imported)
    response = RestClient.post Attendance::HOST + '/api/v0/imports',
                    :app_key => Attendance::API_KEY,
                    :import => {
                      :object => 'TimeSlot',
                      :account_name => self.import.account.name,
                      :csv_file => csv,
                      :headers => [
                        'external_id',
                        'name',
                        'padma_uid',
                        'start_at',
                        'end_at',
                        'sunday',
                        'monday',
                        'tuesday',
                        'wednesday',
                        'thursday',
                        'friday',
                        'saturday',
                        'observations',
                        nil,
                        nil
                      ]
                    }
    if response.code == 201
      # If import was created successfully create a time_slot importer
      #that will show the status of this import
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Attendance::HOST + '/api/v0/imports/' + remote_import_id)
    end
  end

  def finished?
    self.realtime_status == 'finished'
  end

  def ready?
    self.import.import_modules.where(type: 'ContactsImportModule').first.finished?
  end

  def my_name
    "Time Slots"
  end

end
