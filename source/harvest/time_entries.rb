require_relative './utils'

module Harvest
  class TimeEntries

    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def for(user_id: nil, spent_date: nil, project_id: nil)
      @entries.select do |entry|
        (user_id.nil? || entry["user"]["id"] == user_id) &&
        (spent_date.nil? || entry["spent_date"] == Harvest::stringify_date(spent_date)) &&
        (project_id.nil? || entry["project"]["id"] == project_id.to_i)
      end
    end

  end
end
