class AttendanceImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Attendance::API_KEY}
  end

  def delegate_import
    if Rails.env == 'development'
      csv = open(self.import.import_file.attendances.path)
    else
      csv = open(self.import.import_file.attendances.url)  
    end

    # Send file to attendance module using import api
    # first header: external id, fifth and sixth headers: created at, updated at
    response = RestClient.post  Attendance::HOST + '/api/v0/imports',
                                :app_key => Attendance::API_KEY,
                                :import => {
                                  :object => 'Attendance',
                                  :account_name => self.import.account.name,
                                  :csv_file => csv,
                                  :headers => [
                                    nil,
                                    'time_slot_external_id',
                                    'contact_external_id',
                                    'attendance_on',
                                    nil,
                                    nil
                                  ]
                                }
    if response.code == 201
      # If import was created successfully create a attendance importer
      # that will show the status of this import
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Attendance::HOST + '/api/v0/imports/' + remote_import_id)
    end
  end
  
  def finished?
    self.realtime_status == 'finished'
  end

  def ready?
    self.import.import_modules.where(type: 'TimeSlotImporter').first.finished?
  end

end