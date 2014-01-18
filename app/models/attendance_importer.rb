class AttendanceImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Attendance::API_KEY}
  end

  def map_status (response)
    JSON.parse(response)['status']
  end
 
  def delegate_import
    if Rails.env == 'development'
      csv = open(self.import.import_file.attendances.path)
    else
      csv = open_tmp_file(self.import.import_file.attendances.url)
    end

    # Send file to attendance module using import api
    # first header: external id, fifth and sixth headers: created at, updated at
    response = RestClient.post  Attendance::HOST + '/api/v0/imports',
                                app_key: Attendance::API_KEY,
                                account_name: self.import.account.name,
                                import: {
                                  object: 'Attendance',
                                  csv_file: csv,
                                  headers: [
                                    '',
                                    'time_slot_external_id',
                                    'contact_external_id',
                                    'attendance_on',
                                    '',
                                    ''
                                  ]
                                }
    if response.code == 201
      # If import was created successfully create a attendance importer
      # that will show the status of this import
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Attendance::HOST + '/api/v0/imports/' + remote_import_id.to_s)
    end
  end

  def ready?
    self.import.import_modules.where(type: 'TimeSlotImporter').first.finished?
  end

  def my_name
    "Attendances"
  end

end
