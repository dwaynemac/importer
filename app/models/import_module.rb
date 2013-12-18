class ImportModule < ActiveRecord::Base
  belongs_to :import

  attr_accessible :name, :status, :status_url, :import, :failed_rows, :ignore_failed_rows

  alias_attribute :resource_uri, :status_url

  after_initialize :set_name

  def self.delegated
    self.where.not(status_url: nil)
  end

  def self.not_delegated
    self.where(status_url: nil)
  end

  def self.not_finished
    self.where("status <> 'finished' OR status IS NULL")
  end

  def ignore_failed_rows=(val)
    return unless self.status == 'pending'

    if val == 'true'
      self.update_attribute :status, 'finished'
    else
      self.update_attribute :status, 'failed'
    end
  end

  # override in child class
  def status_params
  end

  # override in child class
  def parse_status
  end
  
  # override in child class
  def finished?
  end

  # override in child class
  def ready?
  end

  # override in child class
  def my_name
  end

  def set_name
    if new_record?
      self.name = self.my_name if self.name.nil?
    end
  end

  def realtime_status
    if self.status_url.nil?
      if self.ready? && self.status != 'ready'
        self.update_attribute(:status, 'ready')
      elsif self.status != 'waiting'
        self.update_attribute(:status, 'waiting')
      end
    elsif self.status != 'finished'
      response = RestClient.get status_url, :params => status_params
      self.update_attributes(status: parse_status(response))
    end
    self.status
  end

  def self.update_statuses
    self.not_finished.delegated.each do |im|
      im.realtime_status
    end
  end

  # Queries for unfinished import_modules and delegates those that are ready
  def self.delegate_ready_imports
    # FIXME if an import_module's finished status is not "finished" this wont work for it.
    self.not_finished.not_delegated.each do |im|
      begin
        im.delegate_import if im.ready?
      rescue Errno::ECONNREFUSED, RestClient::InternalServerError => e
        Rails.logger.info "#{e.message} Failed connection to #{im.name}"
      end
    end
  end
end
