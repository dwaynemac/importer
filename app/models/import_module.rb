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
  def map_status
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
      self.update_attributes(status: map_status(RestClient.get status_url, :params => status_params))
    end
    self.status
  end

  def open_tmp_file(url)
    open(url)
=begin
    USE simple open-uri
    filename = File.basename(URI.parse(url).path)
    f = File.open(filename, 'a+b')
    f.write(open(url).read)
    f
=end
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
end
