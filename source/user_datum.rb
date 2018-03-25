class UserDatum
  attr_reader :harvest_user_id,
              :tracking_time_user_id,
              :tracking_time_email,
              :tracking_time_password

  def initialize(string)
    raise "bad user datum #{string}" if (string =~ /(\d+):(\d+):([^:]+):(.*)/).nil?
    @harvest_user_id = $1.to_i
    @tracking_time_user_id = $2.to_i
    @tracking_time_email = $3
    @tracking_time_password = $4
  end

end
