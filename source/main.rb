
require 'date'

require_relative './user_datum'
require_relative './harvest/api'
require_relative './tracking_time/api'

require_relative './development_utils'

# Load environment variables

harvest_token = ENV['HARVEST_API_TOKEN']
raise "missing Harvest token" if harvest_token.nil?

harvest_project_id = ENV['HARVEST_PROJECT_ID']
raise "missing Harvest project ID" if harvest_project_id.nil?

user_data = ENV['USER_DATA'].split('||||')
user_datums = user_data.map{|data| UserDatum.new(data)}

tracking_time_target_task_id = ENV['TRACKING_TIME_TARGET_TASK_ID']
raise "missing TT target task ID" if tracking_time_target_task_id.nil?

# Get all time entries from Harvest (all users) for last 30 days

harvest = Harvest::Api.new(token: harvest_token)
harvest_time_entries = harvest.time_entries(from: (Date.today - 30))

# Go through each user, moving their time over

user_datums.each do |user_datum|

  # Get all of the TrackingTime events for this user over the last month

  tracking_time = TrackingTime::Api.new(username: user_datum.tracking_time_email,
                                        password: user_datum.tracking_time_password)

  tt_events = tracking_time.events_by_date(from: Date.today - 31, to: Date.today)

  # Look through all the dates over the past month.  Whenever we find a TT day that has
  # no entries, look for Harvest entries for the same day and transfer them over.

  for days_ago in 2..30
    date = (Date.today - days_ago).strftime

    if tt_events[date].nil?
      harvest_entries_to_add = harvest_time_entries.for(user_id: user_datum.harvest_user_id,
                                                        project_id: harvest_project_id,
                                                        spent_date: date)

      # In Harvest we don't track start and end times, just durations.  TrackingTime
      # however needs absolute start and end times.  So pick an arbitrary start
      # hour that we increment for all entries.

      next_hour = 9

      harvest_entries_to_add.each do |entry_to_add|
        seconds = (entry_to_add["hours"] * 3600).round

        tracking_time.add_event(user_id: user_datum.tracking_time_user_id,
                                task_id: tracking_time_target_task_id,
                                duration_seconds: seconds,
                                start_date_string: date,
                                start_hour: next_hour,
                                notes: entry_to_add["notes"])

        next_hour += 1
      end
    end
  end
end
