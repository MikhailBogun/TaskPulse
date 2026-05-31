class TaskSchedulerJob < ApplicationJob
  queue_as :default

  def perform
    due_tasks = Task.pending.due_now
    due_tasks.find_each do |task|
      TaskExecutorJob.perform_later(task.id)
    end
  end
end
