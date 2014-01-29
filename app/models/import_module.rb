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

  # override in child class if required
  def handle_failed_rows?
    false
  end

  # override in child class
  def status_params
  end

  # override in child class
  # @return [String]
  def map_status
  end

  # override in child class
  # @return [Integer]
  def map_processed_lines(response)
  end
  
  def finished?
    self.realtime_status == 'finished'
  end

  def failed?
    self.realtime_status == 'failed'
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
      if self.status != 'ready' && self.ready?
        self.update_attribute(:status, 'ready')
      elsif self.status != 'waiting' && !self.ready?
        self.update_attribute(:status, 'waiting')
      end
    elsif self.status != 'finished' && self.status != 'failed' && self.status != 'rolledback'
      self.update_attributes(status: map_status(get_remote_status))
    end
    self.status
  end

  # @return [Integer]
  def processed_lines
    return 0 if status_url.blank?
    @processed_lines ||= map_processed_lines(get_remote_status)
  end

  def open_tmp_file(url)
    tmp = open(url) # this is open-uri open.
    tmp.meta_add_field 'content-type', 'text/csv'
    tmp
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
        Rails.logger.info "checking #{im.type}"
        if im.ready?
          Rails.logger.info "#{im.type} ready, delegating."
          im.delegate_import 
        else
          Rails.logger.info "#{im.type} not ready."
        end
      rescue Errno::ECONNREFUSED, RestClient::InternalServerError => e
        Rails.logger.info "#{e.message} Failed connection to #{im.name}"
      rescue RestClient::Exception => e
        Rails.logger.warn "#{im.type} delegation failed."
      end
    end
  end

  private

  def get_remote_status(skip_cache=false)
    return if status_url.blank?
    remove_instance_variable(:@get_remote_status) if skip_cache
    @get_remote_status ||= RestClient.get status_url, :params => status_params
  end
end
