class TaskMapper

  def initialize(tracking_time_tasks:)
    @tracking_time_tasks = tracking_time_tasks
    @string_to_tasks = {}
  end

  def best_tracking_time_task_for(value)
    return nil if value.nil?

    @string_to_tasks[value] ||= begin
      value = value.to_s.downcase

      tracking_time_tasks.each do |tt_task|

      end
    end



  end


end
