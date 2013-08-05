class Account < ActiveRecord::Base

  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :current_users, :class_name => "User", :foreign_key => "current_account_id"

  # Hook to Padma Account API
  # @param [TrueClass] cache: Specify if Cache should be used. default: true
  # @return [PadmaAccount]
  def padma(cache=true)
    api = (cache)? Rails.cache.read([self,"padma"]) : nil
    if api.nil?
      api = PadmaAccount.find(self.name)
    end
    Rails.cache.write([self,"padma"], api, :expires_in => 5.minutes) if cache && !api.nil?
    return api
  end

end
