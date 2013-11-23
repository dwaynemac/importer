class TrialLessonImporter < ImportModule

  # @return [Hash] params that should be sent to status_url
  def status_params
    {:app_key => Attendance::API_KEY}
  end

  def parse_status (response)
    JSON.parse(response)['status']
  end
 
  def delegate_import
    if Rails.env == 'development'
      csv = open(self.import.import_file.trial_lessons.path)
    else
      csv = open(self.import.import_file.trial_lessons.url)  
    end

    # Send file to attendance module using import api
    response = RestClient.post  Attendance::HOST + '/api/v0/imports',
                                app_key: Attendance::API_KEY,
                                import: {
                                  object: 'TrialLesson',
                                  account_name: self.import.account.name,
                                  csv_file: csv,
                                  headers: [
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
                                }
    if response.code == 201
      # If import was created successfully create a trial lesson importer
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

  def my_name
    "Trial Lessons"
  end

end
