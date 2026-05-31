class TaskExecutorJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)
    TaskExecutors::RunScan.call(task: task)
  end
end
