module Harvest

  def self.stringify_date(date)
    case date
    when String
      return date
    when Date
      date.strftime
    else
      raise "Unknown date format"
    end
  end

end
