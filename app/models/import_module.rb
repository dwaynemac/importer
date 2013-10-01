class ImportModule < ActiveRecord::Base
  belongs_to :import

  attr_accessible :name, :status
end
