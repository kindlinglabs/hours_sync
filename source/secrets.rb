module Secrets

  def self.harvest_api_token
    ENV['HARVEST_API_TOKEN'] || raise("missing Harvest token")
  end

  def self.harvest_project_id
    ENV['HARVEST_PROJECT_ID'] || raise("missing Harvest project ID")
  end

  def self.user_datums
    raw_user_data = ENV['USER_DATA'] || raise("missing user data")
    user_data = raw_user_data.split('||||')
    user_data.map{|data| UserDatum.new(data)}
  end

end
