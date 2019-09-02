module TrackingTime
  class Project

    attr_reader :id, :name, :customer

    def initialize(id:, name:, customer: nil)
      @id = id
      @name = name
      @customer = customer
    end

  end
end
