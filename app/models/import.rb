class Import < ActiveRecord::Base
  belongs_to :account

  mount_uploader :import_file, ImportFileUploader

  attr_accessible :import_file

  has_many :modules
end
