module TaskExecutors
  class RunScan < ApplicationService
    def initialize(task:)
      @task = task
    end

    def call
      @task.update!(status: :running)
      started_at = Time.current

      begin
        output = execute_task
        duration = Time.current - started_at

        @task.update!(status: :success, last_run_at: Time.current)
        @task.task_logs.create!(status: "success", output: output, duration_seconds: duration)
      rescue StandardError => e
        @task.update!(status: :failed)
        @task.task_logs.create!(status: "failed", output: e.message)
        raise
      end
    end

    private

    def execute_task
      # Placeholder — Phase 4 will wire in real external API calls
      "Task #{@task.id} executed successfully"
    end
  end
end
