module TrackingTime
  class Task
    attr_reader :id, :name, :have_used, :num_users, :number_code, :name_text

    def initialize(id:, name:, have_used:, num_users: nil, project: nil)
      @id = id
      @name = name.downcase
      @have_used = have_used
      @num_users = num_users
      @project = project

      @name.match(/(\#\d+)?(.*)/)

      @number_code = $1
      if @number_code
        @number_code = @number_code[1..-1].to_i
      end

      @name_text = $2.strip
    end
  end
end
