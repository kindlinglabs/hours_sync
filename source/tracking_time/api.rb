require_relative 'task'
require_relative 'project'
require_relative 'customer'

module TrackingTime
  class Api
    include HTTParty

    base_uri "app.trackingtime.co/api/v4/"

    # debug_output $stdout # <= will spit out all request details to the console

    def initialize(username:, password:)
      @username = username
      @password = password
    end

    def get(url, options={})
      options.merge!(
        basic_auth: {
          username: @username,
          password: @password
        },
        headers: {
          "User-Agent" => 'Hours Sync (jps@kindlinglabs.com)'
        }
      )

      url = "/" + url if url[0] != '/'

      self.class.get(url, options)
    end

    def post(url, options={})
      options.merge!(
        basic_auth: {
          username: @username,
          password: @password
        },
        headers: {
          "User-Agent" => 'Hours Sync (jps@kindlinglabs.com)'
        }
      )

      url = "/" + url if url[0] != '/'

      self.class.post(url, options)
    end

    def events(from:, to:)
      entries = []

      url = "events?from=#{from.strftime}&to=#{to.strftime}"
      page = 0
      remaining = true

      while remaining do
        batch = get(url + "&page=#{page}")
        batch_entries = batch.parsed_response['data']
        remaining = false if batch_entries.size != 50
        entries += batch_entries
        page += 1
      end

      entries
    end

    def events_by_date(from:, to:)
      events(from: from, to: to).group_by{|ev| ev["start"].split(' ')[0]}
    end

    def tasks
      get("tasks")
    end

    def my_tasks(user_id)
      response = get("users/#{user_id}/trackables")
      JSON.parse(response.body)["data"]["projects"].flat_map do |raw_project|
        raw_customer = raw_project["customer"]
        customer = raw_customer ? Customer.new(id: raw_customer["id"], name: raw_customer["name"]) : nil

        project = Project.new(id: raw_project["id"], name: raw_project["name"], customer: customer)

        raw_project["tasks"].map do |task|
          Task.new(id: task["id"],
                   name: task["name"],
                   have_used: task["users"].any?{|user| user["id"] == user_id},
                   num_users: task["users"].size,
                   project: project)
        end
      end
    end

    def add_event(user_id:, task_id:, start_date_string:, start_hour: 9, duration_seconds:, notes: "")
      start_date_time = "#{start_date_string} #{start_hour.to_s.rjust(2,"0")}:00:00"
      end_date_time = (DateTime.parse(start_date_time) + 1.0*duration_seconds/(24*3600)).strftime("%Y-%m-%d %H:%M:%S")

      post("events/add?user_id=#{user_id}" \
                     "&task_id=#{task_id}" \
                     "&duration=#{duration_seconds}" \
                     "&start=#{start_date_time}" \
                     "&end=#{end_date_time}" \
                     "&notes=#{notes}")
    end

    def delete_event(event_id:)
      post("events/delete/#{event_id}")
    end
  end
end
