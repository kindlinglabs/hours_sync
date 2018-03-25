require 'httparty'
require 'date'
require_relative './utils'
require_relative './time_entries'

module Harvest
  class Api
    include HTTParty

    base_uri "api.harvestapp.com/v2/"

    # debug_output $stdout # <= will spit out all request details to the console

    def initialize(token:)
      @token = token
    end

    def get(url, options={})
      options.merge!(
        headers: {
          "Harvest-Account-ID" => ENV['HARVEST_ACCOUNT_ID'],
          "Authorization" => "Bearer #{@token}",
          "User-Agent" => "Hours Sync",
        }
      )

      url = "/" + url if url[0] != '/'

      self.class.get(url, options)
    end

    def time_entries(from: nil, to: nil)
      entries = []

      url = "time_entries?"
      url += "from=#{Harvest::stringify_date(from)}" if !from.nil?
      url += "&to=#{Harvest::stringify_date(to)}" if !to.nil?
      page = 1
      remaining = true

      while remaining do
        batch = get(url + "&page=#{page}")
        batch_entries = batch.parsed_response["time_entries"]
        remaining = false if batch_entries.size != 100
        entries += batch_entries
        page += 1
      end

      Harvest::TimeEntries.new(entries)
    end

  end
end
