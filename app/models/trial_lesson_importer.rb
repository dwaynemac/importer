class TrialLessonImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Attendance::API_KEY}
  end

  def map_status (response)
    JSON.parse(response)['status']
  end

  def map_processed_lines(response)
    json = JSON.parse(response)
    if json && json['import']
      failed = json['import']['failed_rows'].to_i
      successfull = json['import']['imported_ids'].to_i
      failed + successfull
    end
  end
 
  def delegate_import
    if Rails.env == 'development'
      csv = open(self.import.import_file.trial_lessons.path)
    else
      csv = open_tmp_file(self.import.import_file.trial_lessons.url)
    end

    # Send file to attendance module using import api
    response = RestClient.post  Attendance::HOST + '/api/v0/imports',
                                app_key: Attendance::API_KEY,
                                account_name: self.import.account.name,
                                import: {
                                  object: 'TrialLesson',
                                  csv_file: csv,
                                  headers: headers
                                }
    if response.code == 201
      # If import was created successfully create a trial lesson importer
      # that will show the status of this import
      remote_import_id = JSON.parse(response.body)['id']
      self.update_attributes(status_url: Attendance::HOST + '/api/v0/imports/' + remote_import_id.to_s)
    end
  end

  def ready?
    self.import.import_modules.where(type: 'TimeSlotImporter').first.finished?
  end

  def my_name
    "Trial Lessons"
  end

  def headers
    case self.import.source_system
      when 'kshema'
        [
          '', #external_id
          'contact_external_id',
          'time_slot_external_id',
          'padma_uid',
          'trial_on',
          '', #created_at
          '', #updated_at
          'archived',
          'absence_reason',
          'confirmed',
          'assisted'
        ]
      when 'sys'
        %w()
      when 'other'
        %w()
    end
  end

end
